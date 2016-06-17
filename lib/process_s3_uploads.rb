module ProcessS3Uploads



  @@s3_process_folder = 'lightroom_exports/'
  @@hash_delimiter = '##'
  @@key_value_delimiter = '#'


  @@staff_id = 127127

  @@project_start = '2016-02-01'
  @@project_end = '2016-02-01'
  @@project_title = 'Headshots'
  @@project_description = 'Headshots taken at the Catapult Chicago office.'

  @@task_title = 'Portrait Photography'
  @@task_description = 'Onsite portraits'
  @@task_hours = 1
  @@task_rate = 20.00
  @@detailed_descriptions = true


  @@invoice_exists = {}
  @@invoice_needed = {}



  def process!

    ###########################################################################
    ## Loop through the AWS 'exports' folder for photos and create projects
    ###########################################################################

    user_metadata = {}
    create_projects = {}
    existing_projects = {}
    create_accounts = {}

    bucket_objects = AwsMethods.get_bucket_objects(AWS_S3_PROJECTS_BUCKET, @@s3_process_folder) rescue network_error

    unless bucket_objects.any?

      #########################################################################
      ## Nothing to process
      #########################################################################
      puts 'No items in the "' + @@s3_process_folder + '" folder to process'


    else

      bucket_objects.each do |object|

        #########################################################################
        ## Pull filename data from lightroom export
        #########################################################################

        filename = object.key.split('/').last
        metadata = extract_metadata(filename)


        #########################################################################
        ## Find the billing account, based on input, otherwise create a new one
        #########################################################################
        account = process_account(metadata)


        if metadata['email']

          #########################################################################
          ## Find or create new User
          #########################################################################
          user = User.find_by_email(metadata['email'])

          if user.nil?

            passCode = Devise.friendly_token.first(8)
            user = User.new(
                {
                    email: metadata['email'],
                    password: passCode,
                    password_confirmation: passCode
                })

            user.skip_confirmation!
            user.save

          end


          #########################################################################
          ## Update/create user profile
          ########################################################################
          profile = user.profile
          profile.company_name = metadata['company'] if profile.company_name.blank?
          profile.name_first = metadata['name_first'] if profile.name_first.blank?
          profile.name_middle = metadata['name_middle'] if profile.name_middle.blank?
          profile.name_last = metadata['name_last'] if profile.name_last.blank?
          profile.save



          #########################################################################
          ## Set single users to their own account
          #########################################################################
          unless metadata['billing_email']

            account_user = account.users.find_by_id(user.id)

            if account_user.nil?
              account.account_users.create(user_id: user.id)
            end

          end


          user_metadata[user] = metadata




          #########################################################################
          ## If the project exists, process under existing project
          #########################################################################
          project_title = @@project_title

          if @@detailed_descriptions
            project_title += ' - ' + user.profile.full_name
          end

          project = user.projects.find_by_project_title_and_project_description_and_project_start_and_project_end(project_title, @@project_description,@@project_start,@@project_end)

          if project.present?
            (existing_projects[project] ||= []).push(object)
          end

          #########################################################################
          ## Push object into a grouping by user, one project per user set
          #########################################################################
          (create_projects[user] ||= []).push(object)


        else

          #########################################################################
          ## Push object into a grouping by account, to be visible by everyone
          ## on that account
          #########################################################################
          user_metadata[account] = metadata
          (create_accounts[account] ||= []).push(object)


        end


      end



      #########################################################################
      ## Loop through grouping and create accounts and projects
      #########################################################################
      create_projects.each do |user, s3_objects|

        #########################################################################
        ## Find the account
        #########################################################################
        account = process_account(user_metadata[user])


        #########################################################################
        ## Create project
        #########################################################################
        project = create_project(account)
        if @@detailed_descriptions
          project.title += ' - ' + user.profile.full_name
          project.save
        end



        #########################################################################
        ## Bind to project users
        #########################################################################
        project_user = ProjectUser.create(project_id: project.id, user_id: user.id)
        project_user.save


        #########################################################################
        ## Add this project to the list of projects for this account, for billing
        #########################################################################
        save_to_invoice(user_metadata[user], account, project)


        #########################################################################
        ## Attach exported objects
        #########################################################################
        s3_objects.each do |object|
          process_uploaded_object(object, project)
        end

        #########################################################################
        ## Create tasks
        #########################################################################
        task = create_tasks(project)
        if @@detailed_descriptions
          task.description += ' for ' + user.profile.full_name
          task.save
        end


      end




      #########################################################################
      ## Loop through grouping and create accounts and projects
      #########################################################################
      create_accounts.each do |account, s3_objects|

        #########################################################################
        ## Create project
        #########################################################################
        project = create_project(account)
        if @@detailed_descriptions
          project.title += ' - ' + account.name
          project.save
        end


        #########################################################################
        ## Give every unique account project user access to this project
        #########################################################################

        account_users = Set.new

        account.projects.each do |sub_project|
          sub_project.users.each do |user|
            account_users.add(user)
          end
        end

        account.users.each do |user|
          account_users.add(user)
        end

        account_users.each do |user|

          #########################################################################
          ## Bind to project users
          #########################################################################
          project_user = ProjectUser.create(project_id: project.id, user_id: user.id)
          project_user.save
        end



        #########################################################################
        ## Add this project to the list of projects for this account, for billing
        #########################################################################
        save_to_invoice(user_metadata[user], account, project)


        #########################################################################
        ## Attach exported objects
        #########################################################################
        s3_objects.each do |object|
          process_uploaded_object(object, project)
        end



        #########################################################################
        ## Create tasks
        #########################################################################
        task = create_tasks(project)
        if @@detailed_descriptions
          task.description += ' for ' + account.name
          task.save
        end


      end




      #########################################################################
      ## Create invoices
      #########################################################################

      @@invoice_exists.each do |invoice, projects|
        projects.each do |project|
          project.invoice = invoice
          project.save
        end
      end


      @@invoice_needed.each do |account, projects|
        invoice = account.invoices.find_by_bill_date_and_description(@@project_end, @@project_description)

        if invoice.nil?
          invoice = account.invoices.new

          invoice.title = @@project_title
          invoice.description = @@project_description
          invoice.bill_date = @@project_end

          invoice.category = 'Receivable'
          invoice.status = 'Paid'
          invoice.save
        end

        projects.each do |project|
          project.invoice = invoice
          project.save
        end
      end


    end

  end






  def process_account(metadata)

    if metadata['billing_email']
      billing_email = metadata['billing_email']
      billing_name = metadata['company']

    else

      billing_email = metadata['email']
      billing_name = metadata['name_first']
      billing_name += ' ' + metadata['name_middle'] if metadata['name_middle']
      billing_name += ' ' + metadata['name_last']

    end

    account = Account.find_by_billing_email_and_billing_name(billing_email, billing_name)

    if account.nil?
      account = Account.new
      account.name = billing_name
      account.billing_name = billing_name
      account.billing_email = billing_email
      account.company_name = metadata['company']
      account.permissions = 220
      account.save
    end


    #########################################################################
    ## If a user already exists under this billing email,
    # ## allow the user to view the account details
    #########################################################################
    billing_user = User.find_by_email(billing_email)

    if billing_user
      account_user = account.users.find_by_id(billing_user.id)
      if account_user.nil?
        account.account_users.create(user_id: billing_user.id)
      end
    end


    return account

  end






  def extract_metadata(string)
    data = string.split(@@hash_delimiter)
    data.each {|value| value.chomp!('-') }
    metadata = Hash[data.map {|pair| pair.split(@@key_value_delimiter)}]

    return metadata
  end






  def create_project(account)

    project = account.projects.new
    project.title = @@project_title
    project.description = @@project_description
    project.start = @@project_start
    project.end = @@project_end
    project.category = 'Billable'
    project.status = 'Invoiced'
    project.save

    return project

  end







  def create_tasks(project)
    task = project.tasks.new
    task.staff_id = @@staff_id
    task.start = project.start
    task.end = project.start

    task.title = @@task_title
    task.description = @@task_description

    task.hours_actual = @@task_hours
    task.rate_actual = @@task_rate

    task.category = 'Production'
    task.task_type = 'Fixed'
    task.status = 'Complete'
    task.save

    return task

  end






  def save_to_invoice(metadata, account, project)

    invoice_id = metadata['invoice_id']
    if invoice_id.present?

      invoice = Invoice.find_by_id(invoice_id)
      if invoice.present?
        (@@invoice_exists[invoice] ||= []).push(project)

      else
        (@@invoice_needed[account] ||= []).push(project)
      end

    end
    
  end






  def process_uploaded_object(s3_object, model)

    attachment = model.images.new

    filename = s3_object.key.split('/').last
    file_metadata = extract_metadata(filename)

    moved_object = s3_object.move_to(attachment.s3_path + filename)

    attachment.image_file_name = filename
    attachment.image_file_size     = moved_object.content_length
    attachment.image_content_type  = moved_object.content_type
    attachment.image_updated_at    = moved_object.last_modified
    attachment.captured_filename    = file_metadata['sequence'][0..-5]
    attachment.save

    if attachment.image.reprocess!
      moved_object.delete
    end

  end

end

