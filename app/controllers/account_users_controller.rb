class AccountUsersController < ApplicationController

  # GET /account_users
  # GET /account_users.json
  def index
    @account_users = AccountUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @account_users }
    end
  end

  # GET /account_users/1
  # GET /account_users/1.json
  def show
    @account_user = AccountUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account_user }
    end
  end

  # GET /account_users/new
  # GET /account_users/new.json
  def new
    @account_user = AccountUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account_user }
    end
  end

  # GET /account_users/1/edit
  def edit
    @account_user = AccountUser.find(params[:id])
  end

  # POST /account_users
  # POST /account_users.json
  def create
    @account_user = AccountUser.new(params[:account_user])

    respond_to do |format|
      if @account_user.save
        format.html { redirect_to @account_user, notice: 'Account user was successfully created.' }
        format.json { render json: @account_user, status: :created, location: @account_user }
      else
        format.html { render action: "new" }
        format.json { render json: @account_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /account_users/1
  # PUT /account_users/1.json
  def update
    @account_user = AccountUser.find(params[:id])

    respond_to do |format|
      if @account_user.update(params[:account_user])
        format.html { redirect_to @account_user, notice: 'Account user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_users/1
  # DELETE /account_users/1.json
  def destroy
    @account_user = AccountUser.find(params[:id])
    @account_user.destroy

    respond_to do |format|
      format.html { redirect_to account_users_url }
      format.json { head :no_content }
    end
  end
end
