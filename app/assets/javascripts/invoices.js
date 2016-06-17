///////////////////////////////////////////
// Configure click action to send an email
///////////////////////////////////////////
$(".clicker-email").click(function(e){

    $('#email_sending_modal').foundation('open');

    $.ajax({
        type: "POST",
        dataType: "script",
        url: '/invoices/send_invoice',
        contentType: 'application/json',
        data: JSON.stringify({invoice_id: invoice_id}),
        success: function(response){
            data = jQuery.parseJSON(response);
            $('#sent_to_email').html(data.join(", "));
            $('#email_sending_modal').foundation('close');
            $('#email_sent_modal').foundation('open');
        }
    });

});
