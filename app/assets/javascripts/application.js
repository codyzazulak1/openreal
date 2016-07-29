// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .
//= require map

$(function(){ $(document).foundation(); });

var autocomplete;
var formFilled = false;

// google places autocomplete
function autoComplete() {
  var defaultBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(55.04841493732514, 180),
    new google.maps.LatLng(75.87533278202616, -180)
  );
  var addressInput = document.getElementById('addressInput');
  var options = {
    bounds: defaultBounds,
    types: ['address'],
    componentRestrictions: {country: 'ca'}
  };

  autocomplete = new google.maps.places.Autocomplete(addressInput, options);
  autocomplete.addListener('place_changed', populateFormFields);
}

// populate the address form based on the google places api response
function populateFormFields() {
  place = autocomplete.getPlace();
  console.log(place);

  if (place.address_components) {
    var addressFirst = place.address_components[0].long_name + ' ' + place.address_components[1].long_name;
    // var addressSecond = place.address_components[0].long_name + ' ' + place.address_components[1].long_name;
    var addressCity = place.address_components.reverse()[4].long_name;
    var addressPostal = place.address_components[0].long_name;
    var addressLat = place.geometry.location.lat;
    var addressLng = place.geometry.location.lng;
    $('#addressForm').find('#addressFirst').val(addressFirst);
    // $('#addressForm').find('#addressSecond').val(addressSecond);
    $('#addressForm').find('#addressCity').val(addressCity);
    $('#addressForm').find('#addressPostal').val(addressPostal);
    $('#addressForm').find('#addressLat').val(addressLat);
    $('#addressForm').find('#addressLng').val(addressLng);
  }
  formFilled = true;
  console.log('final submit');
  $('#addressForm input:submit').click();
}

$(document).ready(function(){

  // carousel
  $('.photo-carousel .photo-slide').css('background-image', function(){
    return "url(" + $(this).data('bg') + ")";
  });

  // listing images
  $('.listing-img').css('background-image', function(){
    return "url(" + $(this).data('bg') + ")";
  });

  // listing filters
  $('#filter-btn').click(function(e){
    e.preventDefault();
    $('.listing-filters').slideToggle();
  });

  $('#cancel-btn').click(function(e){
    e.preventDefault();
    $('.listing-filters').slideToggle();
  });


  // listing overview
  $('.listing-body>ul>li').click(function(){
    var pid = $(this).data('pid');
    // var marker;
    $('#p-' + pid).toggle();
    mapMarkers.forEach(function(m){
      if (m.pid === pid) {
        var marker = m;
        console.log(marker);
        infoWindows.forEach(function(info){
          if (info.pid === pid) {
            closeAllInfoWin();
            info.open(map, marker);
            $(".gm-style-iw").prev("div").hide();
          }
        });
      }
    });
        
  });

  $('.listing-overview>.close-btn').click(function(e){
    e.preventDefault();
    $(this).parent('.listing-overview').toggle();
  });


  // initialize the sign in form
  showForm($('#signin-radios').children('input[type=radio]:checked').attr('name'));

  // attach listener to sign in radio buttons
  $('#signin-radios').children('input[type=radio]').click(function(e){
    $(this).siblings().prop('checked', false);
    showForm($(this).prop('name'));
  });
  
  // sign in modal
  $('#signinmodal form').on('submit', function(e){
    e.preventDefault();
    var email = $(this).find('input[name*="email"]').attr('name');
    var emailVar = $(this).find('input[name*="email"]').val();
    var password = $(this).find('input[name$="[password]"]').attr('name');
    var passwordVar = $(this).find('input[name$="[password]"]').val();
    // var remember_me = $(this).find('input[name="remember_me"]:checked');
    // console.log($(this), email, password,remember_me);
    var data = {};
    data[email] = emailVar;
    data[password] = passwordVar;
    
    $.ajax({
      url: $(this).attr('action'),
      type: 'post',
      // contentType: 'application/json',
      dataType: 'json',
      data: data,
      headers: {
        'X-CSRF-Token': $(this).find('input[name="authenticity_token"]').val(),
      },
      error: function(xhr) {
        console.error (xhr);
      },
      success(data) {
        $('#signinmodal').foundation('close');
        window.location.reload(false);
      }
    });
  });

  // check if the address form is populated by google places api
  $('#addressForm').submit(function(e){
    if (!formFilled) {
      e.preventDefault();
      console.log('cancel submission');
    }
  });
});

// switch between different user type
function showForm(name) {
  $('#signinmodal form').hide();
  $('#' + name + '-signin').show();
}




