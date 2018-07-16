import $ from 'jquery';
window.jQuery = $;
window.$ = $;

$(document).ready(function() {
  // hide elements on page load
  let userName;
  let userPhoneNumber;
  $('.sk-fading-circle').hide();
  $('#success').hide();
  $('#user-edit').hide();

  // hand form submissions
  $('#user-signup').submit((event) => {
    $('small.text-danger').text('');
    event.preventDefault();
    if (validateForm('#user-signup')) {
      submitSignUpData();
    }
  });

  $('#user-signin').submit((event) => {
    event.preventDefault();
    if (validateForm('#user-signin')) {
      submitSignInData();
    }
  });

  function renderSpinner() {
    $('#user-signup').hide();
    $('.sk-fading-circle').show();
  }

  function renderForm() {
    $('.sk-fading-circle').hide();
    $('#user-signup').show();
  }

  // sign up
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

  // sign in
  function submitSignInData () {
    let signInData = {
      authenticity_token: $('#authenticity_token')[0].value,
      user: {
        name: $('form#user-signin input[name="user[name]"]')[0].value,
        phone_number: $('form#user-signin input[name="user[phone-number]"]')[0].value
      }
    };
    $.post('/user_sign_in', signInData).done(function (response){
      renderUserEditForm(response);
    }).fail(function (response) {
      $('#sign-in-warning')[0].innerText = 'The information provided does not match any accounts';
    });
  }

  function renderUserEditForm (userData) {
    $('#user-signin').hide();
    $('#user-edit').show();
    $('#sign-in h3.text-center')[0].innerText = 'Manage your message settings';
    $('#user-edit input[name="user[name]"]')[0].value = userData.name;
    $('#user-edit input[name="user[phone-number]"]')[0].value = userData.phone_number;
    $('#user-edit input[type="checkbox"]').map((index,el) => {
      el.checked = userData[el.id]
    })
  }


  function parseWeekdayValues () {
    let data = {};
    const elements = $("input[type='checkbox']");
    for (element of elements) {
      data[element.id] = element.checked
    }
    return(data)
  }
  // validation
  function validateForm (formSelector) {
    let valid = true;
    if (!validName(formSelector)) {
      $(`${formSelector} small#name-warning`)[0].innerText = 'Please enter your username';
      valid = false;
    }

    if (!validPhone(formSelector)) {
      $(`${formSelector} small#phone-warning`)[0].innerText = 'Please enter a valid phone number';
      valid = false;
    }
    return valid;
  }

  function validName (formSelector) {
    return $(`${formSelector} input[name="user[name]"]`)[0].value !== ''
  }

  function validPhone (formSelector) {
    const phoneRegex = /^\(?([0-9]{3})\)?[- ]?([0-9]{3})[- ]?([0-9]{4})$/;
    return $(`${formSelector} input[name="user[phone-number]"]`)[0].value.match(phoneRegex);
  }

  function handleSignupError (errors) {
    if (errors.phone_number && errors.phone_number.includes('has already been taken')) {
      $('#submission-warning')[0].innerText = 'That phone number is already taken';
    }
  }
});
