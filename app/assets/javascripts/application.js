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
//= require dropzone

$(function(){ $(document).foundation(); });
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

// autocomplete in seller form
function autoCompleteSeller() {
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

  // only attach autocomplete on the address form
  if (addressInput) {
    autocomplete = new google.maps.places.Autocomplete(addressInput, options);
    autocomplete.addListener('place_changed', populateSellerForm);
  }

  // prevent form submission
  document.addEventListener("keydown", function(event) {
    if (event.keyCode === 13) {
      event.preventDefault();
    }
  });
}

function populateSellerForm() {
  var place = autocomplete.getPlace();

  if (place.address_components) {
    var addressFirst = place.address_components[0].long_name + ' ' + place.address_components[1].long_name;
    // var addressSecond = place.address_components[0].long_name + ' ' + place.address_components[1].long_name;
    var addressCity = place.address_components.reverse()[4].long_name;
    var addressPostal = place.address_components[0].long_name;
    var addressLat = place.geometry.location.lat;
    var addressLng = place.geometry.location.lng;
    $('#addressForm').find('#addressInput').val(addressFirst);
    // $('#addressForm').find('#addressSecond').val(addressSecond);
    $('#addressForm').find('#addressCity').val(addressCity);
    $('#addressForm').find('#addressPostal').val(addressPostal);
    $('#addressForm').find('#addressLat').val(addressLat);
    $('#addressForm').find('#addressLng').val(addressLng);
  }
}

// populate the address form based on the google places api response
function populateFormFields() {
  var place = autocomplete.getPlace();

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
    $('#detail-btn').attr('href', "/properties/" + pid);
 
    
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

function hideOverview() {

  $('#close-btn').addClass('hide');
  $('#filter-btn').show();
  $('.listing-footer').hide();
  overviewToggled = false;
}

// find Sold properties and set to false always on toggle
function soldProps(){ 
  Array.prototype.forEach.call(document.getElementsByClassName('listing-badge sold'), function(element){$(element).prev().css({
    filter: 'blur(3px)',
    cursor: 'default'
    });
    $(element).prev().prev().css('cursor', 'default');
   
    });
}

// initialize listings
function initListings() {
  
  soldProps();
  $('.listing-body>ul>li').click(function(){
    if(!($(this).find('span').hasClass('listing-badge sold'))){

      var pid = $(this).data('pid');
      toggleOverview(pid);
      overviewToggled = true;

    }

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

  $('.switch-btn').click(function(e){
    e.preventDefault();
    $('#map-view').toggleClass('show-for-medium');
    $('#listing-view').toggleClass('show-for-medium');
    google.maps.event.trigger(map, "resize");
  });

  $('#submit-filter').click(function(e){
    e.preventDefault();
    $('#update-checkbox').attr("checked", false);
    updateOnDrag = false;
    var filters = $('.listing-filters>form');
    filters.find('input[name="bound-east"]').removeAttr("value");
    filters.find('input[name="bound-west"]').removeAttr("value");
    filters.find('input[name="bound-north"]').removeAttr("value");
    filters.find('input[name="bound-south"]').removeAttr("value");
    filters.submit();
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
  $.validate({
    form: "#customer-signin",
    module: 'html5',
    errorMessagePosition : 'top',
    scrollToTopOnError: true,
    borderColorOnError: '#ec5840',
    submitErrorMessageCallback: function($form, errorMessages, config) {
      var container = $form.children('.form-error');
      var result = "";
      // console.log(errorMessages);
      if (errorMessages.length) {
        errorMessages.forEach(function(msg){
          result += "<div>" + msg + "</div>";
        });

        if (!container.length) {
          $form.prepend("<div class='form-error'>"+ result +"</div>");
        } else {
          container.html(result);
        }
      } else {
        container.remove();
      }
    }
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
    var form = $(this);
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
      error: function(response) {
        // console.error (response.responseJSON.error);
        form.prepend("<div class='form-error'><span>"+ response.responseJSON.error +"</span></div>");
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
    }
  });
  

  // validation before form submission
  $('#new-property-form').on('click', function(event) {
    // console.log(event);
    var node = event.target.id === "submit-btn" ? event.target.attributes.name.nodeValue : undefined;
    if (node && node === "commit") {
      $.validate({
        module: 'html5',
        errorMessagePosition : 'inline',
        borderColorOnError: '',
      });
    } else {
      // skip all validation if 'back' button is pressed
      // $('input').on('beforeValidation', function(value, lang, config) {
      //   $(this).attr('data-validation-skipped', 1);
      // });
    }
  });

  

});

// switch between different user type
function showForm(name) {
  $('#signinmodal form').hide();
  $('#' + name + '-signin').show();
}




