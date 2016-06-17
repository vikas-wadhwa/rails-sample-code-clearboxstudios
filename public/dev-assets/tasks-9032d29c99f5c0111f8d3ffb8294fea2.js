///////////////////////////////////////////
// Configure accordian for Tasks and Media
///////////////////////////////////////////

$(function() {
  $(".accordion")
    .accordion({
      header: "> div > h1", 
      heightStyle: 'content',
      collapsible: true,
      active: false
    });

 $("#super_content_frame").css("min-height", '75em');
});


  
///////////////////////////////////////////
// Initialize datepickers
///////////////////////////////////////////
$(function() {
  $("#date-end").datepicker({
      dateFormat : "mm-dd-yy",
      showButtonPanel: true
  });

  $("#date-start").datepicker({
    dateFormat : "mm-dd-yy",
    showButtonPanel: true
  });
});
