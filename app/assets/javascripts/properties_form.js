$(document).ready(function(){
				
	if (	$('input[type=checkbox]').length > 0 ) {
		
		if ($('input:checkbox:checked').length == 0){	

			$('.cb-sell').each(function(e){
				$(this).attr('required', true)								
			})
		}

		$('.cb-sell').on('click', function(){
			
			if ($(this).is(':checked')){
				$('.cb-sell').each(function(){$(this).removeAttr('required')})
			

				if (($('input:checkbox:checked').length > 1) && ($('input[type=checkbox]').last().is(':checked'))){
					$('input[type=checkbox]').last().prop('checked', false)
				}

				if (($('input:checkbox:checked').length > 1) && ($(this)[0].id == $('input[type=checkbox]').last()[0].id)){
					$('.cb-sell').prop('checked', false)
					$('input[type=checkbox]').last().prop('checked', true)
				} 
				else if ($(this)[0].id == $('input[type=checkbox]').last()[0].id)	{
					$('.cb-sell').prop('checked', false);
					$('input[type=checkbox]').last().prop('checked', true)
				}
			
			}
			else if ($('input:checkbox:checked').length == 0) {
				$('.cb-sell').each(function(){$(this).attr('required', true)})
			}
		})


	} // if checkbox length
})

