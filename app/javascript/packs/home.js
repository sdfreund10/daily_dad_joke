import $ from 'jquery';
window.jQuery = $;
window.$ = $;

$(document).ready(function() {
  let userName;
  let userPhoneNumber;
  $('#user-signup').submit((event) => {
    event.preventDefault();
    if (validateForm()) {
      submitSignUpData();
    }
  });

  $('#user-signin').submit((event) => {
    event.preventDefault();
    if (validateForm()) {
      submitSignInData();
    }
  });

  $('.sk-fading-circle').hide();
  $('#success').hide();

  function renderSpinner() {
    $('#user-signup').hide();
    $('.sk-fading-circle').show();
  }

  function renderForm() {
    $('#name-warning')[0].innerText = '';
    $('#phone-warning')[0].innerText = '';
    $('.sk-fading-circle').hide();
    $('#user-signup').show();
  }

  function submitSignUpData () {
    renderSpinner();
    let postData = signUpFormData();
    $.post('/users', postData).done(function (response) {
      $('.sk-fading-circle').fadeOut(function() {
        $('#success').show();
      });
    }).fail(function (response) {
      handleSignupError(response.responseJSON)
      renderForm();
    });
  }

  function signUpFormData () {
    return(
      {
        authenticity_token: $('#authenticity_token')[0].value,
        user: {
          name: $('form#user-signup input[name="user[name]"]')[0].value,
          phone_number: $('form#user-signup input[name="user[phone-number]"]')[0].value,
          sunday: $('form#user-signup #sunday')[0].checked,
          monday: $('form#user-signup #monday')[0].checked,
          tuesday: $('form#user-signup #tuesday')[0].checked,
          wednesday: $('form#user-signup #wednesday')[0].checked,
          thursday: $('form#user-signup #thursday')[0].checked,
          friday: $('form#user-signup #friday')[0].checked,
          saturday: $('form#user-signup #saturday')[0].checked
        }
      }
    )
  }

  function submitSignInData () {

  }

  function signInFormData () {
    return(
      {
        authenticity_token: $('#authenticity_token')[0].value,
        user: {
          name: $('form#user-signin input[name="user[name]"]')[0].value,
          phone_number: $('form#user-signin input[name="user[phone-number]"]')[0].value
        }
      }
    )
  }

  function parseWeekdayValues () {
    let data = {};
    const elements = $("input[type='checkbox']");
    for (element of elements) {
      data[element.id] = element.checked
    }
    return(data)
  }

  function validateForm () {
    let valid = true;
    if (!validName()) {
      $('#name-warning')[0].innerText = 'Please enter a name';
      valid = false;
    }

    if (!validPhone()) {
      $('#phone-warning')[0].innerText = 'Please enter a valid phone number';
      valid = false;
    }
    return valid;
  }

  function validName () {
    return $('input[name="user[name]"]')[0].value !== ''
  }

  function validPhone () {
    const phoneRegex = /^\(?([0-9]{3})\)?[- ]?([0-9]{3})[- ]?([0-9]{4})$/;
    return $('input[name="user[phone-number]"]')[0].value.match(phoneRegex);
  }

  function handleSignupError (errors) {
    if (errors.phone_number && errors.phone_number.includes('has already been taken')) {
      $('#submission-warning')[0].innerText = 'That phone number is already taken';
    }
  }
});
