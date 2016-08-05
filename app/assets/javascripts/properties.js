//= require fancybox

$(window).scroll(function(){
  if ($('body.properties.show').length) {
    // current position
    var cur_pos = $(this).scrollTop();
    var paddingHeight = Number($('.property-details').css('padding-top').replace("px", ""));
    var floatOffset = Number($('.floating-container').css('margin-top').replace("px", "").replace("-", ""));
    var bottom_pos = $('.similar-listings').offset().top - $('.floating-box').outerHeight() - paddingHeight * 2;
    // console.log(cur_pos, bottom_pos);
    var floatOn = $('.photo-carousel').outerHeight() + $('nav').outerHeight() + $('.property-overview').outerHeight() - floatOffset;
  }
  
  if ($(window).width() >= 640) {
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
  }
});

// add controls to orbit slider
Foundation.Orbit.prototype.pause = function() {
  this.timer.pause();
}

Foundation.Orbit.prototype.restart = function() {
  this.timer.restart();
}

$(document).ready(function(){
  $('.photo-carousel .photo-slide').css('background-image', function(){
    return "url(" + $(this).data('bg') + ")";
  });

  var fancyOptions = {
    prevEffect  : 'none',
    nextEffect  : 'none',
    padding: 0,
    parent: "body",
    type: 'image',
    helpers : {
      thumbs  : {
        width : 50,
        height  : 50
      }
    },
    beforeShow : function(){ $('.orbit').foundation('pause'); },
    afterClose : function(){ $('.orbit').foundation('restart'); }
  };

  $('.photo-carousel').click(function(){
    var slideIndex = $('.orbit-slide.is-active').data('slide');
    fancyOptions.index = slideIndex;
    $.fancybox.open($(".photo-thumb"), fancyOptions);
  });

  $('#submit-filter').click(function(){
    // $('.listing-filters').slideToggle();
  });
});