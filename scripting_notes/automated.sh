#########################################################################
### Create new users with new account, full privileges
#########################################################################


account = 
            { 
                name: 'Slalom Consulting - Accounts Payable', 
                billing_name: 'Slalom Consulting - Accounts Payable', 
                billing_email: 'ap@slalom.com', 
                company_name: 'Slalom Consulting, LLC', 
                company_address_street: '180 N Stetson Ave Suite 5300', 
                company_address_city: 'Chicago', 
                company_address_state: 'IL', 
                company_address_zip: '60601', 
                company_phone: '' , 
                company_website: '' 
            }
            
    #########################################################################
    ### Find the billing account, based on input, otherwise create a new one
    #########################################################################
    
	account = Account.find_by_billing_email_and_name_and_company_name(userListItem[:account][:billing_email], userListItem[:account][:name], userListItem[:account][:company_name])
    
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
	
	
	
            
userList = [
                { 
                name_first: 'Vikas', name_middle: '', name_last:  'Wadhwa', 
                email: 'vikas.wadhwa@clearboxstudios.com'
                },
                
                { 
                name_first: 'Vikas', name_middle: '', name_last:  'Wadhwa', 
                email: 'vikas.wadhwa@clearboxstudios.com'
                },               
]

userList.each do |userListItem|



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
    
        #########################################################################
        ### Create user profile
        #########################################################################
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

            #########################################################################
            ### Give user access to account and all current projects
            #########################################################################
            account.account_users.create(:user_id => user.id)
            account.projects.each do |project|
                project_user = ProjectUser.create(project_id: project.id, user_id: user.id)
                project_user.save!
            end


        end
    
    end
end
    