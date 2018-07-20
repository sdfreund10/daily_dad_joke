import $ from 'jquery';
import modal from 'bootstrap';
window.jQuery = $;
window.$ = $;

$(document).ready(function() {
  let currentUser;

  // hide elements on page load
  $('.sk-fading-circle').hide();
  $('#success').hide();
  $('#edit-success').hide();
  $('#user-edit').hide();
  $('#unsubscribe-button').click(() => {
    if(validateForm('#unsubscribe-form')){
      $('#unsubscribeModal').modal('show');
    }
  })

  $('#delete-user-button').click(() => {
    if (validateForm('#unsubscribe-form')) {
      $('#deleteUserModal').modal('show');
    }
  })

  // hand form submissions
  function handleSubmission (formId, submit) {
    $(formId).submit((event) => {
      event.preventDefault();
      if (validateForm(formId)) {
        submit();
      }
    });
  }
  handleSubmission('#user-signup', submitSignUpData);
  handleSubmission('#user-signin', submitSignInData);
  handleSubmission('#user-edit', submitEditData);

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
    let postData = userData('#user-signup');
    $.post('/users', postData).done(function (response) {
      $('.sk-fading-circle').fadeOut(function() {
        $('#success').show();
      });
    }).fail(function (response) {
      handleSignupError(response.responseJSON)
      renderForm();
    });
  }

  function userData (form) {
    // recieves form id
    return(
      {
        authenticity_token: $('#authenticity_token')[0].value,
        user: {
          name: $(`form${form} input[name="user[name]"]`)[0].value,
          phone_number: $(`form${form} input[name="user[phone-number]"]`)[0].value,
          sunday: $(`form${form} input[name='user[sunday]']`)[0].checked,
          monday: $(`form${form} input[name='user[monday]']`)[0].checked,
          tuesday: $(`form${form} input[name='user[tuesday]']`)[0].checked,
          wednesday: $(`form${form} input[name='user[wednesday]']`)[0].checked,
          thursday: $(`form${form} input[name='user[thursday]']`)[0].checked,
          friday: $(`form${form} input[name='user[friday]']`)[0].checked,
          saturday: $(`form${form} input[name='user[saturday]']`)[0].checked
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
      currentUser = { name: response.name, phone_number: response.phone_number };
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
      el.checked = userData[el.id.split('-').pop()];
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

  // edit user
  function submitEditData () {
    let userEditData = {...userData('#user-edit'), ...{find_params: currentUser} };
    $.ajax({ url: '/users', type: 'PATCH', data: userEditData }).done(function (response) {
      resetWarnings()
      $('#edit-success').fadeIn('fast').delay(2000).fadeOut('slow');
    }).fail(function (response) {
      $('#edit-warning').text(
        'There was a problem updating your settings. Try again later'
      )
      throw response;
    });
  }

  // validation
  function validateForm (formSelector) {
    let valid = true;
    if (!validName(formSelector)) {
      $(`${formSelector} small#name-warning`).text('Please enter your username');
      valid = false;
    }

    if (!validPhone(formSelector)) {
      $(`${formSelector} small#phone-warning`).text('Please enter a valid phone number');
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
  function resetWarnings () {
    $('small.text-danger').text('');
  }
});
