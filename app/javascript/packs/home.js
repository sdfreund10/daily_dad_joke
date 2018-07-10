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

  function submitData () {
    renderSpinner();
    let postData = formData();
    $.post('/users', postData).done(function (response) {
      console.log(response);
      $('.sk-fading-circle').fadeOut(function() {
        $('#success').show();
      });
    }).fail(function (response) {
      console.log(response);
      handleSignupError(response.responseJSON)
      renderForm();
    });
  }

  function formData () {
    return(
      {
        authenticity_token: $('#authenticity_token')[0].value,
        user: {
          name: $('input[name="user[name]"]')[0].value,
          phone_number: $('input[name="user[phone-number]"]')[0].value,
          sunday: $('#sunday')[0].checked,
          monday: $('#monday')[0].checked,
          tuesday: $('#tuesday')[0].checked,
          wednesday: $('#wednesday')[0].checked,
          thursday: $('#thursday')[0].checked,
          friday: $('#friday')[0].checked,
          saturday: $('#saturday')[0].checked
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
