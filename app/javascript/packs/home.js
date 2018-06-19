import $ from 'jquery';
window.jQuery = $;
window.$ = $;
$(document).ready(function() {
  $('#user-signup').submit(function(event) {
    event.preventDefault();
    if (validateForm()) {
      submitData();
    }
  });

  $('.sk-fading-circle').hide();

  function renderSpinner() {
    $('#user-signup').hide();
    $('.sk-fading-circle').show();
  }

  function renderForm() {
    $('.sk-fading-circle').hide();
    $('#user-signup').show();
  }

  function submitData () {
    renderSpinner();
    let postData = {
      authenticity_token: $('meta[name="csrf-token"]')[0].content,
      user: {
        name: $('input[name="user[name]"]')[0].value,
        email: $('input[name="user[email]"]')[0].value,
        phone_number: $('input[name="user[phone-number]"]')[0].value
      }
    };
    $.post('/users', postData).always(function (response) {
      renderForm();
      console.log(response);
    });
  }

  function validateForm () {
    let valid = true;
    if (!validName()) {
      $('#name-warning')[0].innerText = 'Please enter a name'
      valid = false;
    }

    if (!validEmail()) {
      $('#email-warning')[0].innerText = 'Please enter a valid email'
      valid = false;
    }

    if (!validPhone()) {
      $('#phone-warning')[0].innerText = 'Please enter a valid phone number'
      valid = false;
    }
    return valid;
  }

  function validName () {
    return $('input[name="user[name]"]')[0].value !== ''
  }

  function validEmail () {
    const emailRegex = /^([A-Za-z0-9_\-.])+@([A-Za-z0-9_\-.])+\.([A-Za-z]{2,4})$/;
    return $('input[name="user[email]"]')[0].value.match(emailRegex)
  }

  function validPhone () {
    const phoneRegex = /^\(?([0-9]{3})\)?[- ]?([0-9]{3})[- ]?([0-9]{4})$/;
    return $('input[name="user[phone-number]"]')[0].value.match(phoneRegex)
  }
});
