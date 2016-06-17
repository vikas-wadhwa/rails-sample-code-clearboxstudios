///////////////////////////////////////////
// Submit changes on click of
// Staff Member checkbox
///////////////////////////////////////////
$('#profile_staff_member').on('change', function() {
    $(this).closest('form').submit();
});