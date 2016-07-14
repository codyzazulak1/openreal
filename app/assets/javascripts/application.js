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
    var address = autocomplete.getPlace();
    console.log(address);
  });
}

$(document).ready(function(){

  showForm($('#signin-radios').children('input[type=radio]:checked').attr('name'));

  $('#signin-radios').children('input[type=radio]').click(function(e){
    $(this).siblings().prop('checked', false);
    showForm($(this).prop('name'));
  });

  function showForm(name) {
    $('#signinmodal form').hide();
    $('#' + name + '-signin').show();
  }

});


