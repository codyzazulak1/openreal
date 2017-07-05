$(document).ready(function(){
	$('#add_photos_form').fileupload({
		dataType: 'script',
		add: function(e, data) {
      var file, types;
      types = /(\.|\/)(gif|jpe?g|png)$/i;
      file = data.files[0];
      if (types.test(file.type) || types.test(file.name)) { data.context = $(tmpl("template-upload", file));
          //$('#add_photos_form').append(data.context);
          return data.submit(); } else {
          return alert("" + file.name + " is not a gif, jpeg, or png image file"); } },
    progressall: function(e, data) {
    	var progress = parseInt(data.loaded / data.total * 100, 10);

    	$('#progress .bar').css('width', progress + '%');
    	if (progress < 100){
    		$('#percentage').html('' + progress + '%');
    	}
    	else if (progress == 100) {
    		$('#percentage').text('' + progress + '%' + ' Done!');
    	} },
      done: function(e, data){
        $('#all_photos_show').empty();
        $('#percentage').html('<p> Photos uploaded.</p>');
      }

  }).bind('fileuploadprocessfail',function(){
  	$('#progress').append('<p> Processing ' + data.files[data.index].name + " failed. </p>" + "\n");
  })
})

