$(document).ready(function(){
				
	if (	$('input[type=checkbox]').length > 0 ) {
		
		if ($('input:checkbox:checked').length == 0){	

			$('.cb-sell').each(function(e){
				$(this).attr('required', true)								
			})
		}

	} // if checkbox length

	$('.cb-sell').click(function(){

			if ($(this).is(':checked')){
				$('.cb-sell').each(function(){$(this).removeAttr('required')})
				
	
				if ($('input[type=checkbox]').last()){
					if ($('input[type=checkbox]').last().is(':checked')){			
						$('.cb-sell').prop('checked', false)
						$('input[type=checkbox]').last().prop('checked', true)
					}
				} 
			}
			else if ($('input:checkbox:checked').length == 0) {
				$('.cb-sell').each(function(){$(this).attr('required', true)})
			}
	})

})

