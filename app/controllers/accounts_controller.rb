class AccountsController < ApplicationController



  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!




  ################################################
  # GET /accounts

  ################################################

  def index

    results = Account.user_readable(current_user)

    respond_to do |format|

      if results.count == 1
        @account = results.first
        format.html { redirect_to account_url(@account)}

      else
        @accounts = results.page(params[:page]).per(@@results_per_page)
        format.html # index.html.erb
      end

    end
    
  end






  ################################################
  # GET /accounts/1
  ################################################
  def show
    
    @account = Account.find(params[:id])
    
    if @account.user_readable(current_user)

      @projects = Project.includes(:images, :videos, :account, :invoice).user_readable(current_user).merge(@account.projects)
      @invoices = Invoice.includes(:projects, :tasks).user_readable(current_user)


      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @account }
      end
    
    else
      not_authorized
    end
  end





  ################################################
  # GET /accounts/new
  ################################################

  def new
    
    @account = current_user.accounts.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account }
    end
    
  end





  ################################################
  # GET /accounts/1/edit
  ################################################
  def edit

    @account = Account.find(params[:id])
    
    if @account.user_editable(current_user)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @account }
      end
    
    else
      not_authorized
    end
  end





  ################################################
  # POST /accounts
  ################################################

  def create
  
    @account = current_user.accounts.new(params[:account])

    respond_to do |format|

      if @account.save && @account.account_users.create(:user_id => current_user.id)

        format.html { redirect_to accounts_url, notice: 'Account was successfully created.' }
        format.json { render json: @account, status: :created, location: @account }

      else

        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }

      end
    end
  end





  ################################################
  # PUT /accounts/1
  ################################################

  def update
   
    @account = Account.find(params[:id])
    if Account.user_updateable(current_user).include?(@account)
      respond_to do |format|
        if @account.update(params[:account])
          format.html { redirect_to accounts_url, notice: 'Account was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @account.errors, status: :unprocessable_entity }

        end
      end
    else
      not_authorized
    end
  end



  ################################################
  # POST /accounts
  # POST /accounts.json
  ################################################

  def search

    @accounts = []
    
    PgSearch.multisearch(params['search-string']).where(:searchable_type => "Account").find_each do |document|
      @accounts << document.searchable if Account.user_readable(current_user).include?(document.searchable)
    end

    respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
    end
    
  end


  ################################################
  # DELETE /accounts/1
  ################################################

  def destroy

    @account = Account.find(params[:id])
    @account.destroy if @account.destroyable? && Account.user_updateable(current_user).include?(@account)

    respond_to do |format|

      format.html { redirect_to accounts_url }
      format.json { head :no_content }

    end
  end
end
