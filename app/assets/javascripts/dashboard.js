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
        console.log(data);
      }
    });
  });

  $('.side-panel-menu li').on('click', function(){

    console.log("clicked");
    $el = $(this);

    $('.side-panel-menu li.active').removeClass('active');
    $el.addClass('active');

  });

});
