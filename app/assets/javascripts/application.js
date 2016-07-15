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
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });

function autoComplete() {
  var defaultBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(55.04841493732514, 180),
    new google.maps.LatLng(75.87533278202616, -180)
  );
  var addressInput = document.getElementById('addressInput');
  var searchBox;
  var options = {
    bounds: defaultBounds,
    types: ['address'],
    componentRestrictions: {country: 'ca'}
  };

  autocomplete = new google.maps.places.Autocomplete(addressInput, options);
  autocomplete.addListener('place_changed', function() {
    var addressResponse = autocomplete.getPlace();
    console.log(addressResponse);
    populateFormFields(addressResponse);
  });
}

$(document).ready(function(){

  showForm($('#signin-radios').children('input[type=radio]:checked').attr('name'));

  $('#signin-radios').children('input[type=radio]').click(function(e){
    $(this).siblings().prop('checked', false);
    showForm($(this).prop('name'));
  });
  
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
});

function showForm(name) {
  $('#signinmodal form').hide();
  $('#' + name + '-signin').show();
}

function populateFormFields(response) {
  var addressFirst = response.address_components[0].long_name + ' ' + response.address_components[1].long_name;
  // var addressSecond = response.address_components[0].long_name + ' ' + response.address_components[1].long_name;
  var addressCity = response.address_components[2].long_name;
  var addressPostal = response.address_components[6].long_name;
  var addressLat = response.geometry.location.lat;
  var addressLng = response.geometry.location.lng;
   $('#addressForm').find('#addressFirst').val(addressFirst);
   // $('#addressForm').find('#addressSecond').val(addressSecond);
   $('#addressForm').find('#addressCity').val(addressCity);
   $('#addressForm').find('#addressPostal').val(addressPostal);
   $('#addressForm').find('#addressLat').val(addressLat);
   $('#addressForm').find('#addressLng').val(addressLng);
}


