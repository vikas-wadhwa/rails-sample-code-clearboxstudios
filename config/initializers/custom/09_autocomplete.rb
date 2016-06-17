module RailsJQueryAutocomplete
  module Autocomplete
    module ClassMethods
      def autocomplete(object, method, options = {}, &block)

        define_method("get_prefix") do |model|
          if defined?(Mongoid::Document) && model.include?(Mongoid::Document)
            'mongoid'
          elsif defined?(MongoMapper::Document) && model.include?(MongoMapper::Document)
            'mongo_mapper'
          else
            'active_record'
          end
        end
        define_method("get_autocomplete_order") do |method, options, model=nil|
          method("#{get_prefix(get_object(options[:class_name] || object))}_get_autocomplete_order").call(method, options, model)
        end

        define_method("get_autocomplete_items") do |parameters|
          method("#{get_prefix(get_object(options[:class_name] || object))}_get_autocomplete_items").call(parameters)
        end

        define_method("autocomplete_#{object}_#{method}") do

          method = options[:column_name] if options.has_key?(:column_name)

          term = params[:term]

          if term && !term.blank?
            #allow specifying fully qualified class name for model object
            class_name = options[:class_name] || object
            items = get_autocomplete_items(:model => get_object(class_name), :options => options, :term => term, :method => method)
          else
            items = {}
          end

          ###################################################################################################
          ##  Added the options[:extra_methods] attribute, so we can pass both a method and it's parameters
          ###################################################################################################
          #render :json => json_for_autocomplete(items, options[:display_value] ||= method, options[:extra_data], &block), root: false
          render :json => json_for_autocomplete(items, options[:display_value] ||= method, options[:extra_data], options[:extra_methods], &block), root: false
        end
      end

    end


    def json_for_autocomplete(items, method, extra_data=[], extra_methods={})

      items = items.collect do |item|

        hash = {"id" => item.id.to_s, "label" => item.send(method), "value" => item.send(method)}

        extra_data.each do |datum|
          hash[datum] = item.send(datum)
        end if extra_data

        extra_methods.each do |method, parameter|
          hash[method] = item.send(method, parameter)
        end if extra_methods

        hash
      end
      if block_given?
        yield(items)
      else
        items
      end
    end


  end
end


module RailsJQueryAutocomplete
  module Orm
    module ActiveRecord
      def active_record_get_autocomplete_items(parameters)
        model   = parameters[:model]
        term    = parameters[:term]
        options = parameters[:options]
        method  = options[:hstore] ? options[:hstore][:method] : parameters[:method]
        scopes  = Array(options[:scopes])
        where   = options[:where]
        limit   = get_autocomplete_limit(options)
        order   = active_record_get_autocomplete_order(method, options, model)

        items = (::Rails::VERSION::MAJOR * 10 + ::Rails::VERSION::MINOR) >= 40 ? model.where(nil) : model.scoped

        scopes.each do |scope|
          if scope.class == Hash
            items = items.send(scope[:scope], term)
          else
            items = items.send(scope)
          end

        end unless scopes.empty?

        items = items.select(get_autocomplete_select_clause(model, method, options)) unless options[:full_model]
        items = items.where(get_autocomplete_where_clause(model, term, method, options)).limit(limit).order(order) unless options[:scopes_only]
        items = items.where(where) unless where.blank?

        items
      end
    end
  end
end

