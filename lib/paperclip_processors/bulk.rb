############################################################################
##  found at https://gist.github.com/ruby-railings/8634350
############################################################################

module Paperclip

  # A wrapper for a queued item. Normally this would be a temporary file, but we can't do that, because Paperclip
  # would copy the temporary file before the content is actually written.
  class BulkQueueItem
    attr_reader :destination
    def initialize(destination)
      @destination = destination
    end
  end

  # IO adapter for bulk destinations. We cannot use `Paperclip::FileAdapter` because it performs a copy immediately,
  # i.e. before the resulting file is actually created.
  class BulkQueueItemAdapter < AbstractAdapter
    def initialize(queue_item)
      @tempfile = queue_item.destination
    end
  end

  class Bulk < Processor

    # Method called by Paperclip. This doesn't actually make the output, but determines the file name and pushes the
    # make action to the queue.
    def make
      current_format = File.extname(@file.path)
      basename = File.basename(@file.path, current_format)
      format = options[:format]

      dst = Tempfile.new([basename, format ? ".#{format}" : ''])
      dst.binmode

      queue = @attachment.instance_variable_get(:@paperclip_bulk_processor_queue) || {}

      # Group items by original file name.
      queue[@file.path] ||= []
      queue[@file.path] << {
          destination: dst,
          destination_path: dst.path,
          file: @file,
          file_path: @file.path,
          file_original: @file.original_filename,
          options: @options,
      }
      @attachment.instance_variable_set(:@paperclip_bulk_processor_queue, queue)

      BulkQueueItem.new(dst)
    end
  end

  module BulkQueue
    def self.process(attachment)
      queue = attachment.instance_variable_get(:@paperclip_bulk_processor_queue) || return
      queue.values.each { |tasks| BulkQueueProcessor.new(tasks).process }
      attachment.remove_instance_variable(:@paperclip_bulk_processor_queue)
    end
  end

  class BulkQueueProcessor

    attr_accessor :tasks, :current_geometry, :target_geometry, :format, :whiny, :basename,
                  :animated, :auto_orient

    def initialize(tasks)
      @tasks = tasks

      task = tasks.first
      options = task[:options]

      @file = task[:file]
      @current_geometry = (options[:file_geometry_parser] || Geometry).from_file(@file)

      @format = options[:format]
      @animated = options[:animated].nil? ? true : options[:animated]
      @auto_orient = options[:auto_orient].nil? ? true : options[:auto_orient]

      @current_format = File.extname(@file.path)
      @basename = File.basename(@file.path, @current_format)
    end

    def process
      parameters = []
      parameters << source
      parameters << source_file_options

      parameters << '-write mpr:cache'
      parameters << '+delete'

      tasks.each do |task|

        options = task[:options]

        geometry = options[:geometry]
        @crop = geometry[-1, 1] == '#'
        @target_geometry = (options[:string_geometry_parser] || Geometry).parse(geometry)

        parameters << 'mpr:cache'
        parameters << transformation_command
        parameters << options[:convert_options] # TODO: Split common and special options and move common options up

        destination = shell_quote(File.expand_path(task[:destination].path))
        if task == tasks.last
          parameters << destination
        else
          parameters << '-write'
          parameters << destination
          parameters << '+delete'
        end
      end

      parameters = parameters.flatten.compact.join(' ').strip.squeeze(' ')

      begin
        Paperclip.run('convert', parameters)
      rescue Cocaine::ExitStatusError
        raise Paperclip::Error, "There was an error processing the generated image for #{basename}" if whiny
      rescue Cocaine::CommandNotFoundError
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `convert` command. Please install ImageMagick.")
      end
    end

    private
    def source_file_options
      @source_file_options ||= tasks.collect { |task| task[:source_file_options] }
    end

    def source
      shell_quote("#{File.expand_path(@file.path)}#{'[0]' unless animated?}")
    end

    def transformation_command
      scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
      trans = []
      # TODO: Check if some of this can be moved to the common part of the command line.
      trans << '-coalesce' if animated?
      trans << '-auto-orient' if auto_orient
      trans << '-resize' << %["#{scale}"] unless scale.nil? || scale.empty?
      trans << '-crop' << %["#{crop}"] << '+repage' if crop
      trans << '-layers "optimize"' if animated?
      trans
    end

    def animated?
      animated && (Thumbnail::ANIMATED_FORMATS.include?(format.to_s) || format.blank?) && identified_as_animated?
    end

    def crop?
      !!@crop
    end

    def identified_as_animated?
      Thumbnail::ANIMATED_FORMATS.include? Paperclip.run('identify', '-format %m :file', file: "#{@file.path}[0]").to_s.downcase.strip
    rescue Cocaine::ExitStatusError
      raise Paperclip::Error, "There was an error running `identify` for #{basename}" if whiny
    rescue Cocaine::CommandNotFoundError
      raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `identify` command. Please install ImageMagick.")
    end

    def shell_quote(string)
      return '' if string.nil?
      if RbConfig::CONFIG['host_os'] !~ /mswin|mingw/
        if string.empty?
          "''"
        else
          string.split("'").map { |m| "'#{m}'" }.join("\\'")
        end
      else
        %{"#{string}"}
      end
    end

  end

end


############################################################################
##  These methods MUST appear at the end of this file to work
############################################################################


Paperclip.io_adapters.register Paperclip::BulkQueueItemAdapter do |target|
  target.is_a?(Paperclip::BulkQueueItem)
end
Paperclip.register_processor(:bulk, Paperclip::Bulk)



