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
//= require jquery.form-validator.min

$(function(){ $(document).foundation(); });
// hey
var autocomplete;
var formFilled = false;
var overviewToggled = false;

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
  // console.log(place);

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
  // console.log('final submit');
  $('#addressForm input:submit').click();
}

// toggle listing overview
function toggleOverview(pid) {
  var pid = typeof pid !== 'undefined' ?  pid : null;

  if (overviewToggled && pid !== null) { 
    $('#detail-btn').attr('href', "/properties/" + pid) 
  } 
  else if (!overviewToggled && pid!== null) {
    $('#detail-btn').attr('href', "/properties/" + pid)
    $('#close-btn').toggleClass('hide');
    $('#filter-btn').toggle();
    $('.listing-footer').toggle();
  }
  else {
    $('#close-btn').toggleClass('hide');
    $('#filter-btn').toggle();
    $('.listing-footer').toggle();
  }
}

// initialize listings
function initListings() {

  $('.listing-body>ul>li').click(function(){
    var pid = $(this).data('pid');
    toggleOverview(pid);
    overviewToggled = true;

    mapMarkers.forEach(function(m){
      if (m.pid === pid) {
        var marker = m;
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
}

function initListingImg() {
  $('.listing-img').css('background-image', function(){
    return "url(" + $(this).data('bg') + ")";
  });
}

$(document).ready(function(){

  // carousel
  $('.photo-carousel .photo-slide').css('background-image', function(){
    return "url(" + $(this).data('bg') + ")";
  });

  // listing images
  initListingImg();

  // listing header
  $('#filter-btn').click(function(e){
    e.preventDefault();
    $('.listing-filters').slideToggle();
  });

  $('#cancel-btn').click(function(e){
    e.preventDefault();
    $('.listing-filters').slideToggle();
  });

  $('#close-btn').click(function(e){
    e.preventDefault();
    closeAllInfoWin();
    toggleOverview();
    $('.listing-overview').hide();
    overviewToggled = false;
  });

  initListings();

  $('.loader').hide();

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
      // console.log('cancel submission');
    }
  });
  

  // validation before form submission
  $('#new-property-form').on('click', function(event) {
    // console.log(event.target.attributes.name.nodeValue);
    var validate;
    if (event.target.attributes.name.nodeValue==="commit") {
      validate = $.validate({
        errorMessagePosition : 'inline',
        borderColorOnError: '',
      });
    } else {
      validate = null;
    }
      
  });

  $('#back-btn').click(function(){
    // $('#new-property-form').get(0).reset();
    // $('#new-property-form').submit();
  })

});

// switch between different user type
function showForm(name) {
  $('#signinmodal form').hide();
  $('#' + name + '-signin').show();
}




