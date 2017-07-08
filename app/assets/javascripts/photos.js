$(document).ready(function(){
  var totalfilesuploaded = []
	$('#add_photos_form').fileupload({
		dataType: 'script',

		add: function(e, data) {
      var file, types

      types = /(\.|\/)(gif|jpe?g|png)$/i;

      file = data.files[0];

      totalfilesuploaded.push(file);
      if (totalfilesuploaded.length == 1){
        $('.loaded').html('<p style="text-align: center;">' + 1 + ' photos uploading..</p>');
      } else {
       $('.loaded').html('<p style="text-align: center;">' + $('#add_photos_form').fileupload('active') + ' photos uploading..</p>');
      }
   

      if (types.test(file.type) || types.test(file.name)){
          data.context = $(tmpl("template-upload", file));
          return data.submit(); } 
      else {
        return alert("" + file.name + " is not a gif, jpeg, or png image file"); } 
    },

    progressall: function(e, data) {
    	var progress = parseInt(data.loaded / data.total * 100, 10);

    	$('#progress .bar').css('width', progress + '%');

    	if (progress < 100){
    		$('.bar p').html('' + progress + '%');

        if (progress < 50) {
          $('.bar p').css('color', 'light-grey');
        }
        else if (progress > 50) {
          $('.bar p').css('color', 'white');
        }
      }
    	else if (progress == 100) {
    		$('.bar p').text('' + progress + '%');

        setTimeout(function(){
          
          $('.loaded').html('<p>' + totalfilesuploaded.length + ' Photos uploaded.</p>' + "\n" + '<small><i>If your photo shows up blank with only the name of the file, it is still rendering and will show on reload.</i></small>').css('text-align', 'center');

        }, 1000)
    	} },

      done: function(e, data){
        setTimeout(function(){
           $('#progress .bar').css('width',0);
           $('#percentage').html('');
           totalfilesuploaded.length = 0;
         }, 3500)
      }

  }).bind('fileuploadprocessfail',function(){
  	$('#progress').append('<p> Processing ' + data.files[data.index].name + " failed. </p>" + "\n");
  })
});




