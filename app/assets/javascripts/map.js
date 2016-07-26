var map;
// var markers = [
//   ['Property 1', 49.2447, -123.1359, 4],
//   ['Property 2', 49.2512, -123.1482, 5],
//   ['Property 3', 49.2524, -123.1598, 3]
// ];

var markers = [];
var infoWindows = [];

// console.log(markers);

function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 49.2512, lng: -123.1482},
    zoom: 12,
    zoomControl: true,
    zoomControlOptions: {
        position: google.maps.ControlPosition.RIGHT_TOP
    },
    mapTypeControl: false,
    scaleControl: false,
    streetViewControl: false,
    rotateControl: false,
    fullscreenControl: false
  });

  setMarkers(map);
}
  

function setMarkers(map) {
  
  $.getJSON("/properties.json", function(data){
    data.forEach(function(property){
      var marker = new google.maps.Marker({
        position: {lat: parseFloat(property.address.latitude), lng: parseFloat(property.address.longitude)},
        map: map,
        title: property.address.address_first,
        // zIndex: 5
      });

      var info = 
      // "<div class='marker-info'>" + 
        // "<span>" + 
        property.address.address_first;
        // "</span>" + 
        // "</div>";

      var infowindow = new google.maps.InfoWindow({
        content: info,
        // maxWidth: 200
      });

      infoWindows.push(infowindow);

      marker.addListener('click', function() {
        closeAllInfoWin();
        infowindow.open(map, marker);
        $(".gm-style-iw").prev("div").hide();
      });
    });
  });

  // for (var i = 0; i < markers.length; i++) {
  //   // var marker = markers[i];
  //   var marker = new google.maps.Marker({
  //     position: {lat: marker[1], lng: marker[2]},
  //     map: map,
  //     title: marker[0],
  //     zIndex: marker[3]
  //   });
  // }
}

function closeAllInfoWin() {
  for (var i=0; i<infoWindows.length; i++) {
    infoWindows[i].close();
  }
}

var pin = [49.2447, -123.1359, 4];

function propertyMap() {
  map = new google.maps.Map(document.getElementById('listing-map'), {
    center: {lat: pin[0], lng: pin[1]},
    zoom: 12,
    zoomControl: true,
    zoomControlOptions: {
        position: google.maps.ControlPosition.RIGHT_TOP
    },
    mapTypeControl: false,
    scaleControl: false,
    streetViewControl: false,
    rotateControl: false,
    fullscreenControl: false
  });

  var marker = new google.maps.Marker({
    position: {lat: pin[1], lng: pin[2]},
    map: map
  });
}