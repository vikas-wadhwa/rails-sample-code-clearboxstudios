class SendPdfInvoice < ActionMailer::Base
  helper :email
  default from: "Clearbox Billing"

  def send_pdf_invoice(invoice)

    @invoice = invoice
    @email = invoice.account.billing_email
    @delivery_options  = { user_name: CORPORATE_LOGINS[:gmail_billing][:username],
                          password: CORPORATE_LOGINS[:gmail_billing][:password]
    }

    attachments["Clearbox Studios - Invoice #{invoice.id}"] = {
        mime_type: 'application/pdf',
        content: rendered_pdf(invoice)
    }

    mail to: @email, subject: 'Clearbox Studios - Invoice #' + invoice.id.to_s, delivery_method_options: @delivery_options

  end


  private

  def rendered_pdf(invoice)
    WickedPdf.new.pdf_from_string(rendered_view(invoice), print_media_type: true)
  end

  def rendered_view(invoice)

    @account = invoice.account
    @tasks = invoice.tasks_grouped

    render_to_string partial: 'invoices/email.pdf.erb', locals: { invoice: invoice, account: @account, tasks: @tasks  }
  end


end

