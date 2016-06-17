class InvoicesController < ApplicationController



  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!




  ################################################
  # GET /invoices
  # GET /invoices.json
  ################################################

  def index

    results = Invoice.includes(:projects, :tasks).user_readable(current_user)

    respond_to do |format|

      if results.count == 1
        @invoice = results.first
        format.html { redirect_to invoice_url(@invoice)}

      else
        @invoices = results.page(params[:page]).per(@@results_per_page)
        format.html # index.html.erb
      end

    end

  end



  ################################################
  # GET /invoices/1
  # GET /invoices/1.json
  ################################################

  def show


    @invoice = Invoice.includes(:projects, :tasks).user_readable(current_user, params[:id])

    if @invoice

      @tasks = @invoice.tasks_grouped
      @start_date = nil
      @staff_profile = nil

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @invoice }
        format.pdf do
          render pdf: "clearbox_studios_invoice_" + @invoice.id.to_s,
                 print_media_type: true,
                 show_as_html: params.key?('debug')
        end
      end

    else
      not_authorized
    end


  end



  ################################################
  # GET /invoices/new
  # GET /invoices/new.json
  ################################################

  def new

    if Account.user_readable(current_user).present?

      @accounts = Account.user_readable(current_user)
      @account = @accounts.first

      if params[:account_id]
        @account = Account.user_readable(current_user).find(params[:account_id])

      elsif params[:project_id]
        @account = Project.user_readable(current_user).find(params[:project_id]).account
      end

      @invoice = @account.invoices.build
      @projects = @account.projects.unbilled.sort_by(&:updated_at).reverse

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @invoice }
      end

    else
      respond_to do |format|
        format.html { redirect_to new_account_url, notice: 'Please create a billable account first.' }
      end
    end



  end



  ################################################
  # GET /invoices/1/edit
  ################################################


  def edit

    @invoice = Invoice.user_readable(current_user, params[:id])

    if @invoice && !@invoice.paid?
      @projects = Project.user_readable(current_user).where(invoice_id: [nil, params[:id]], account_id: @invoice.account.id)

    else
      not_authorized
    end

  end


  ################################################
  # POST /invoices
  # POST /invoices.json
  ################################################

  def create

    if Account.user_readable(current_user).present?
      @invoice = Invoice.new(params[:invoice])
      @project_ids = params[:project_ids]

      respond_to do |format|
        if @invoice.save && update_projects(@invoice.id, @project_ids)
          format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
          format.json { render json: @invoice, status: :created, location: @invoice }
        else
          @accounts = Account.user_readable(current_user)
          @account = @invoice.account
          @eligible_projects = current_user.projects.unbilled
          format.html { render action: "new" }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end


    else
      respond_to do |format|
        format.html { redirect_to new_account_url, notice: 'Please create a billable account first.' }
      end
    end

  end


  ################################################
  # PUT /invoices/1
  # PUT /invoices/1.json
  ################################################

  def update

    ## default the category, done in controller to prevent from potential tampering
    params[:invoice][:category] = 'Receivable'

    @invoice = Invoice.find(params[:id])


    if @invoice.unpaid?

      @project_ids = params[:project_ids]

      ## Format the date/time, otherwise the incoming values are ignored during update throw validation errors
      params[:invoice][:bill_date]= Date.strptime(params[:invoice][:bill_date], '%m-%d-%Y')
      params[:invoice][:payment_date]= Date.strptime(params[:invoice][:payment_date], '%m-%d-%Y')

      respond_to do |format|

        if @invoice.update(params[:invoice]) && update_projects(@invoice.id, @project_ids)
          format.html { redirect_to invoices_path, notice: 'Invoice was successfully updated.' }
          format.json { head :no_content }

        else
          @projects = Project.user_readable(current_user).where(invoice_id: [nil, params[:id]], account_id: @invoice.account.id)
          format.html { render action: "edit" }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      end

    else
      not_authorized
    end
  end


  ################################################
  # POST /invoices
  # POST /invoices.json
  ################################################

  def search

    results = []
    @searching = true
    results = Invoice.includes(:projects, :tasks).user_readable(current_user).search_for(params['search-string'])
    @invoices = results.page(params[:page]).per(@@results_per_page)


    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @invoice.errors, status: :unprocessable_entity }
    end

  end


  ################################################
  # POST /invoices/send_invoice
  ################################################
  def send_invoice

    @invoice = Invoice.user_readable(current_user, params['invoice_id'])


    if @invoice && authorized_editor?

      @email = SendPdfInvoice.send_pdf_invoice(@invoice).deliver

      if @email

        response = @email.to.to_json

        respond_to do |format|
          format.json { render json: response }
        end

      else
        network_error
      end


    else
      not_authorized
    end
  end


  ################################################
  # DELETE /invoices/1
  # DELETE /invoices/1.json
  ################################################

  def destroy
    @invoice = Invoice.find(params[:id])

    if authorized_editor? && @invoice.unpaid?

      @invoice.destroy

      respond_to do |format|
        format.html { redirect_to invoices_url }
        format.json { head :no_content }
      end

    else
      not_authorized
    end
  end

  ################################################
  # Return a pdf
  ################################################
  def pdf

    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "clearbox_studios_invoice_" + @invoice.id.to_s,
               template: "invoices/_printable.html.erb",
               print_media_type: true,
               show_as_html: params.key?('debug')
      end
    end
  end



  protected

  ################################################
  # Update projects for a given invoice
  ################################################

  def update_projects(invoice_id, project_ids)

    # Wipe out all references to this invoice in the table
    #@projects = Project.find(:invoice_id = invoice_id)
    #@projects.update_all({:invoice_id => nil})

    Project.where(invoice_id: invoice_id).update_all("invoice_id = null ")


    # Update only the incoming projects with the invoice id
    #@projects = Project.find(project_ids)
    #@projects.update_all({:invoice_id => invoice_id})
    Project.where(id: project_ids).update_all({invoice_id: invoice_id}) unless project_ids.nil?

    return true

  end


  ################################################
  # Define authorized users
  ################################################

  def authorized_viewer?
    current_user.staff_member?
  end

  def authorized_editor?
    current_user.staff_member?
  end

end
