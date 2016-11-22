//= require fancybox
$(document).ready(function() {
  $(".fancybox-thumb").fancybox({
    prevEffect  : 'none',
    nextEffect  : 'none',
    helpers : {
      title : {
        type: 'outside'
      },
      thumbs  : {
        width : 50,
        height  : 50
      }
    }
  });
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

  // $('.photo-thumb').click(function (){
  //   var imgbgk = $(this).data('fancybox-href')
  //   var photoSlide = $('.is-active .photo-slide')

  //   $(this).find('img').each(function(img){
  //     var thumbImage = this.src
  //    $('.photo-carousel .photo-slide').each(function(){
  //         console.log(($(this).data('bg')) === (thumbImage))
  //    });
  //   });
  // })

  // $('.photo-thumb').find('img').each(function(index){ console.log('this is the index ' + index + 'and content' + this.src)});


  var fancyOptions = {
    prevEffect  : 'none',
    nextEffect  : 'none',
    padding: 0,
    parent: "body",
    type: 'image',
    helpers : {
      thumbs  : {
        width : 50,
        height  : 50,
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

  $('#favorite-btn').on('click', function(event){
    event.preventDefault();

    console.log($(this).data("state"));

    if ($(this).data("state") === true){

      $.ajax({

        url: "/customers/"+$(this).data("uid")+"/favorites/"+$(this).data("fid"),
        method: "post",
        dataType: 'json',
        data: {
          "_method": "delete",
          fid: $(this).data("fid")
        },
        success: function(data){
          $('#favorite-btn').data("state", false).html("Save as favorite");
          console.log(data.message);
        }
      });

    } else {

      $.ajax({

        url: "/customers/"+$(this).data("uid")+"/favorites",
        method: "post",
        dataType: 'json',
        data: {
          pid: $(this).data("pid")
        },
        success: function(data){
         $('#favorite-btn').data("fid", data.fid).data("state", true).html("Saved");
        }
      });

    }

  });

  // file upload
  var inputs = document.querySelectorAll( '.file-upload' );
  Array.prototype.forEach.call( inputs, function( input )
  {
    var label  = input.nextElementSibling,
      labelVal = label.innerHTML;

    input.addEventListener( 'change', function( e )
    {
      var fileName = '';
      if( this.files && this.files.length > 1 ) {
        fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
      }
      else {
        fileName = e.target.value.split( '\\' ).pop();
      }

      if( fileName ) {
        label.innerHTML = fileName;
        document.getElementById('submit-btn').value = "Next";
      }
      else {
        label.innerHTML = labelVal;
      }
    });
  });

});
