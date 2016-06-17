
#########################################################################
### Batch remove users
#########################################################################
userGroup = User.where("id > ?", 127177) 
userGroup.each do |user|
 user.destroy
end



#########################################################################
### Sequence alters
#########################################################################
ALTER SEQUENCE users_id_seq RESTART WITH 127180;
ALTER SEQUENCE projects_id_seq RESTART WITH 127179;
ALTER SEQUENCE invoices_id_seq RESTART WITH 127131;



#########################################################################
### Console send mail
#########################################################################
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	:address              => "smtp.gmail.com",
	:port                 => 587,
	:domain               => 'clearboxstudios.com',
	:user_name            => LOGINS[:gmail_accounts][:username],
	:password             => LOGINS[:gmail_accounts][:password],
	:authentication       => 'plain',
	:enable_starttls_auto => true  
}

Rails.application.config.action_mailer.raise_delivery_errors = true
Rails.application.config.action_mailer.default_url_options = { :host => 'http://www.clearboxstudios.com' }
Rails.application.config.assets.initialize_on_precompile = false
Rails.application.config.assets.prefix = "/assets"
Rails.application.config.action_controller.asset_host = 'http://www%d.clearboxstudios.com'
Rails.application.config.action_mailer.asset_host = Rails.application.config.action_controller.asset_host




	


#########################################################################
### Temp
#########################################################################
userVik = User.find_by_email('vikas.wadhwa@clearboxstudios.com')
AutomatedPassword.notify_users(userVik, 'temporary1').deliver

userList = [
  {company_name: 'Clearbox', name_first: 'Vikas', name_last:  'Wadhwa', email: 'vikas.wadhwa@clearboxstudios.com'}
]

userList.each do |user|
	passCode = Devise.friendly_token.first(8)
	userModel = User.find_by_email(user[:email].downcase)
	userModel.password = passCode
	userModel.password_confirmation = passCode
	userModel.save!
	AutomatedPassword.notify_users(userModel, passCode).deliver
end	
	
userModel = User.find_by_email('amy.chelberg@clearboxstudios.com')
userModel.password = 'password1234'
userModel.password_confirmation = 'password1234'
userModel.save!	


email

userModel = User.find_by_email('ethan.linkner@learncore.com')
userModel.password = 'password1234'
userModel.password_confirmation = 'password1234'
userModel.save!	



#########################################################################
### Batch add an account to users
### Take all current user unbilled projects and add to account.
### Then invoice the account.
#########################################################################

	accountData = {}
	accountData[:name]= 'Catapult Chicago'
	accountData[:permissions]= 220
	accountData[:company_name]= 'Catapult Chicago'
	accountData[:company_website]= 'http://www.catapultchicago.com'
	accountData[:company_address_street]= '321 North Clark Street #2550'
	accountData[:company_address_city]= 'Chicago'
	accountData[:company_address_state]= 'IL'
	accountData[:company_address_zip]= '60654'
	accountData[:company_phone]='312-860-0950'
	accountData[:billing_name]= 'Catapult Chicago'
	accountData[:billing_email]= 'april@catapultchicago.com'
	accountData[:billing_phone_home]= ''
	accountData[:billing_phone_work]= ''
	accountData[:billing_phone_mobile]= ''
	accountData[:billing_address_street]= accountData[:company_address_street]
	accountData[:billing_address_city]= accountData[:company_address_city]
	accountData[:billing_address_state]= accountData[:company_address_state]
	accountData[:billing_address_zip]= accountData[:company_address_zip]
	
	account = Account.new(accountData)
    account.save
    #account.account_users.create(:user_id => user.id)
    
    

	
	usersAccountGroup = 
    {
        emails: [
        'kelsey@catapultchicago.com',
        'michelle@catapultchicago.com'
        ]
    }
    
    account = Account.find(127251)
    
    invoice = account.invoices.new
	invoice.category = 'Receivable'
	invoice.title = 'Catapult'
	invoice.description = 'Headshots taken at the Catapult Chicago office for Catapult, Page-Vault, and Learncore members'
	invoice.status = 'Unpaid'
	invoice.bill_date = '2015-05-08'
	invoice.save

    usersAccountGroup[:emails].each do |email|

        user = User.find_by_email(email.downcase)
    
        user.projects.unbilled.each do |project|
            project.account = account
            project.invoice = invoice
            project.save
        end
    
    end


#########################################################################
### Batch create a task for a consecutive set of projects
#########################################################################
start_proj = 127287
end_proj = 127295

(start_proj..end_proj).each do |project_id|

    project = Project.find(project_id)
    user = project.users.first
    task = project.tasks.new
    task.staff_id = 127127
    task.start = project.start
    task.end = project.end
    task.category = 'Production'
    task.task_type = 'Fixed'
    task.status = 'Complete'
    task.title = 'Portrait Photography'
    task.description = 'Portrait Photography'
    task.description += ' for ' + user.profile.full_name unless user.profile.full_name.blank?
    task.hours_actual = 1
    task.rate_actual = 20.00
    task.save!

end




start_proj = 127291
end_proj = 127295

(start_proj..end_proj).each do |project_id|

    project = Project.find(project_id)
    account = project.account
    
	invoice = account.invoices.find_by_bill_date_and_description(project.end, project.description)
	
	if invoice.nil?
        invoice = account.invoices.new
        invoice.category = 'Receivable'
        invoice.title = 'Portrait Photography'
        invoice.description = project.description
        invoice.status = 'Paid'
        invoice.bill_date = project.end
    	invoice.save!
    end
	
    project.invoice = invoice
    project.save!

end




#########################################################################
### Batch add users
### For each, create a random password, a profile, a personal account, 
### mark them as an account user,
### add a new project
### mark them as a project user
#########################################################################


userList = [

{create_user: true, account: { name: 'Ethan Linkner', billing_name: 'Ethan Linkner', billing_email: 'ethan.linkner@learncore.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'Chicago', company_address_zip: 'Chicago', company_phone: 'Chicago' , company_website: '312-860-0950' }, project_users: '', name_first: 'Ethan', name_middle: '', name_last:  'Linkner', email: 'ethan.linkner@learncore.com'},
{create_user: true, account: { name: 'Ryan Leavitt', billing_name: 'Ryan Leavitt', billing_email: 'ryan@learncore.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'Chicago', company_address_zip: 'Chicago', company_phone: 'Chicago' , company_website: '312-860-0950' }, project_users: '', name_first: 'Ryan', name_middle: '', name_last:  'Leavitt', email: 'ryan@learncore.com'},
{create_user: true, account: { name: 'Vishal Shah', billing_name: 'Vishal Shah', billing_email: 'vshahv@learncore.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'Chicago', company_address_zip: 'Chicago', company_phone: 'Chicago' , company_website: '312-860-0950' }, project_users: '', name_first: 'Vishal', name_middle: '', name_last:  'Shah', email: 'vshahv@learncore.com'},
{create_user: false, account: { name: 'Learncore', billing_name: 'Learncore', billing_email: 'ethan.linkner@learncore.com', company_name: 'Learncore', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'IL', company_address_zip: '60654', company_phone: '312-300-6684' , company_website: 'http://www.learncore.com' }, project_users: 'kelsey@catapultchicago.com, april@catapultchicago.com, ethan.linkner@learncore.com, ryan@learncore.com, vshahv@learncore.com', name_first: 'LearnCore Group', name_middle: '', name_last:  '', email: ''},
{create_user: false, account: { name: 'Catapult Chicago', billing_name: 'Catapult Chicago', billing_email: 'april@catapultchicago.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'IL', company_address_zip: '60654', company_phone: '312-860-0950' , company_website: 'http://www.catapultchicago.com' }, project_users: 'kelsey@catapultchicago.com, april@catapultchicago.com', name_first: 'Catapult Group', name_middle: '', name_last:  '', email: ''},
{create_user: true, account: { name: 'Catapult Chicago', billing_name: 'Catapult Chicago', billing_email: 'april@catapultchicago.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'IL', company_address_zip: '60654', company_phone: '312-860-0950' , company_website: 'http://www.catapultchicago.com' }, project_users: '', name_first: 'Chris', name_middle: '', name_last:  'Cain', email: 'ccain@foley.com'},
{create_user: true, account: { name: 'Catapult Chicago', billing_name: 'Catapult Chicago', billing_email: 'april@catapultchicago.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'IL', company_address_zip: '60654', company_phone: '312-860-0950' , company_website: 'http://www.catapultchicago.com' }, project_users: '', name_first: 'Galen', name_middle: '', name_last:  'Mason', email: 'gmason@foley.com'},
{create_user: true, account: { name: 'Catapult Chicago', billing_name: 'Catapult Chicago', billing_email: 'april@catapultchicago.com', company_name: 'Catapult Chicago', company_address_street: '321 North Clark Street #2550', company_address_city: 'Chicago', company_address_state: 'IL', company_address_zip: '60654', company_phone: '312-860-0950' , company_website: 'http://www.catapultchicago.com' }, project_users: '', name_first: 'April', name_middle: '', name_last:  'Lane', email: 'april@catapultchicago.com'},

]

projectUsers = []

userList.each do |userListItem|

    #########################################################################
    ### Find the billing account, based on input, otherwise create a new one
    #########################################################################
    
	account = Account.find_by_billing_email_and_name_and_billing_name(userListItem[:account][:billing_email], userListItem[:account][:name], userListItem[:account][:company_name])
    
    if account.nil?
        account = Account.new
        account.name = userListItem[:account][:name]
        account.permissions = 220
        account.company_name = userListItem[:account][:company_name]
        account.company_website = userListItem[:account][:company_website]
        account.company_address_street = userListItem[:account][:company_address_street]
        account.company_address_city =  userListItem[:account][:company_address_street]
        account.company_address_state =  userListItem[:account][:company_address_state]
        account.company_address_zip =  userListItem[:account][:company_address_zip]
        account.company_phone =  userListItem[:account][:company_phone]
        account.billing_name = userListItem[:account][:billing_name]
        account.billing_email = userListItem[:account][:billing_email]
        account.billing_phone_work = account.company_phone
        account.billing_address_street = account.company_address_street 
        account.billing_address_city = account.company_address_city 
        account.billing_address_state = account.company_address_state 
        account.billing_address_zip = account.company_address_zip 
        account.save!    
	end
	

    #########################################################################
    ### Create a placeholder user
    #########################################################################

    user = User.find_by_email(userListItem[:email])
    
    if user.nil?
    
        passCode = Devise.friendly_token.first(8)
        user = User.new(
        {
          email: userListItem[:email],
          password: passCode,
          password_confirmation: passCode
        })
    
        profile = Profile.new
        profile.company_name = userListItem[:company_name]
        profile.name_first = userListItem[:name_first]
        profile.name_middle = userListItem[:name_middle]
        profile.name_last = userListItem[:name_last]
        
        if userListItem[:create_user]

            user.skip_confirmation!
            user.save!
            profile.user_id = user.id
            profile.save!

            if user.email == userListItem[:account][:billing_email]
                account.account_users.create(:user_id => user.id)
            end

        end
    
    end
    
	
    project = account.projects.new
	project.title = 'Headshots - ' + profile.full_name
	project.description = 'Headshots taken at the Catapult Chicago office for Catapult, Page-Vault, and Learncore members.'
	project.start = '2015-04-29'
	project.end = '2015-04-29'
	project.category = 'External'
	project.status = 'Paid'
	project.save!
	

	if userListItem[:project_users].blank?
	
        project_user = ProjectUser.create(project_id: project.id, user_id: user.id)
        project_user.save!
    
    else 

        projectUsers.push({project_id: project.id, user_emails: userListItem[:project_users].split(',').map(&:strip)})
        
    end
    
    
    task = project.tasks.new
    task.staff_id = 127127
    task.start = project.start
    task.end = project.end
    task.category = 'Production'
    task.task_type = 'Fixed'
    task.status = 'Complete'
    task.title = 'Portrait Photography'
    task.description = 'Portrait Photography'
    task.description += ' for ' + profile.full_name unless profile.full_name.blank?
    task.hours_actual = 1
    task.rate_actual = 20.00
    task.save!
	
	invoice = account.invoices.find_by_bill_date_and_description(project.end, project.description)
	
	if invoice.nil?
        invoice = account.invoices.new
        invoice.category = 'Receivable'
        invoice.title = 'Portrait Photography'
        invoice.description = project.description
        invoice.status = 'Unpaid'
        invoice.bill_date = project.end
    	invoice.save!
    end
	
    project.invoice = invoice
    project.save!

	
end


projectUsers.each do |project_users|

    project_users[:user_emails].each do |email|
        projectUser = User.find_by_email(email)
        
        if projectUser
            project_user = ProjectUser.new(project_id: project_users[:project_id], user_id: projectUser.id)
            project_user.save!
        end
        
    end
    
end