
$(document).ready(function(){

  var map, address, geocoder;
  var markers = [];

	$('.offer-btn').click(function(){
		console.log('c-1');

		$('#e-url').css('background-color', 'lightgrey');
		$('#e-url').css('pointer-events', 'none');
		$('#offer-container').height('5em');
		$('.loader').show();
		$('#offer-container').find('*').not('div.loader, div.spinner, p.wait-text, p > small').remove();
		$('#offer-container').append('<div class="columns small-1 show-for-small-only"><a href="#" class="map-link" target="_blank"><i class="fa fa-map-marker" aria-hidden="true"></i></a></div>')
		if (!map){
      address = $(this).data('address')
      map = new google.maps.Map(document.getElementById('gmap'), {
        zoom: 12,
        center: {lat: -34.397, lng: 150.644}
      });

      geocoder = new google.maps.Geocoder();

      geocodeAddress(geocoder, map, address);

    } else {

      address = $(this).data('address');

      geocoder = null

      geocoder = new google.maps.Geocoder();

      map.setCenter({lat: -34.397, lng: 150.644});

      geocodeAddress(geocoder, map, address);
		}
   })

	function geocodeAddress(geocoder, resultsMap, address) {

    geocoder.geocode({'address': address}, function(results, status) {

      if (status === 'OK') {

        resultsMap.setCenter(results[0].geometry.location);

        for (var i = markers.length - 1; i >= 0; i--) {
          
          markers[i].setMap(null)
        }

        var marker = new google.maps.Marker({

          map: resultsMap,
          position: results[0].geometry.location

        });

        markers.push(marker);

        // directions for view on google.maps.com
        var lat = results[0].geometry.location.lat()

        var lng = results[0].geometry.location.lng()

        var reg = /[\.\,]/g 
        
        var address_search_param = address.replace(reg, '').split(' ').join('+');

        $('.map-link').attr('href', "https://maps.google.com/?q=" + address_search_param)

      } else {

        alert('Geocode was not successful for the following reason: ' + status);

      }

    });

  }

});

