$(document).ready(function(){
  // dashboard status dropdown
  $('.dashboard-listing-status').on('change', function(){
    var el = $(this);
    $.ajax({
      url: el.data('url'),
      type: 'post',
      // contentType: 'application/json',
      dataType: 'json',
      data: {
        "_method": "patch",
        status: el.val()
      },
      error: function(response) {
        console.log(response);
      },
      success(data) {
        el.val(data.status);
      }
    });
  });
});
