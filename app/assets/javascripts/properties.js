$(window).scroll(function(){
  // current position
  var cur_pos = $(this).scrollTop();
  var paddingHeight = Number($('.property-details').css('padding-top').replace("px", ""));
  var floatOffset = Number($('.floating-container').css('margin-top').replace("px", "").replace("-", ""));
  var bottom_pos = $('.similar-listings').offset().top - $('.floating-box').outerHeight() - paddingHeight * 2;
  console.log(cur_pos, bottom_pos);
  var floatOn = $('.photo-carousel').outerHeight() + $('nav').outerHeight() + $('.property-overview').outerHeight() - floatOffset;
  // debugger
  if (cur_pos > floatOn && cur_pos < bottom_pos && !$(".floating-box").hasClass('is-floating')) {
    $(".floating-box").addClass('is-floating');
    $(".floating-box.is-floating").width( $(".floating-box").parent().width() );
  } 
  else if (cur_pos > floatOn && cur_pos >= bottom_pos && $(".floating-box").hasClass('is-floating')) {
    $(".floating-box").addClass('bottom').removeClass('is-floating').css('top', (bottom_pos - $('.floating-box').outerHeight()) + floatOffset - paddingHeight - 2);
  }
  else if (cur_pos > floatOn && cur_pos < bottom_pos) {
    $(".floating-box").addClass('is-floating').removeClass('bottom').removeAttr('style');
    $(".floating-box.is-floating").width( $(".floating-box").parent().width() );
    // console.log('remove');
  }
  else {
    if (cur_pos < floatOn && $(".floating-box").hasClass('is-floating')) {
      $(".floating-box").removeClass('is-floating').removeClass('bottom').removeAttr('style');;
    }
  }
});