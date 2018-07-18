require 'application_system_test_case'

class HomesTest < ApplicationSystemTestCase
  include WaitForAjax
  test 'sign up form rendered on page load' do
    visit root_url
    assert_selector(:css, '#user-signup')
    assert_selector(:xpath, "//input[@name='user[name]']")
    assert_selector(:xpath, "//input[@name='user[phone-number]']")
  end

  test 'submit with blank name' do
    visit root_url
    click_button('Submit')
    assert_equal(find('#name-warning').text, 'Please enter your username')
  end

  test 'submit with blank phone number' do
    visit root_url
    click_button('Submit')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')
  end

  test 'submit with invalid phone number' do
    visit root_url
    fill_in('user[phone-number]', with: '1234')
    click_button('Submit')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')
  end

  test 'renders spinner on form submit' do
    sign_up('Me', '(555) 123-4567')
    assert_selector('.sk-fading-circle')
  end

  test 'renders alert when user with phone-number exists' do
    User.create(name: 'Sample', phone_number: '5551234567')
    sign_up('Test', '(555) 123-4567')
    wait_for_ajax
    assert_equal(
      find('#submission-warning').text,
      'That phone number is already taken'
    )
  end

  test 'renders checkmark with success message when user created' do
    sign_up('Test', '(555) 123-4567')
    assert_selector('#success')
    assert_selector('.checkmark')
    wait_for_ajax
    assert_equal(
      find('#success').text,
      'Success! You should recieve your first dad joke tomorrow :)'
    )
  end

  test 'it has all days of the week rendered' do
    visit root_url
    assert_selector('.weekday-label', count: 7)
    assert_equal(all('.weekday-label').map(&:text), %w(S M T W R F S))
  end

  test 'saturday and sunday are unselected by default' do
    visit root_url
    # assume moday is selected by default -- so its color should be different
    monday_color = find("label[for='user-signup-monday']").native.css_value('color')
    assert_not_equal(
      find("label[for='user-signup-sunday']").native.css_value('color'),
      monday_color
    )
    assert_not_equal(
      find("label[for='user-signup-saturday']").native.css_value('color'),
      monday_color
    )
  end

  test 'weekday labels change color when clicked' do
    visit root_url
    sunday = find("label[for='user-signup-sunday']")
    monday = find("label[for='user-signup-monday']")
    initial_sunday_color = sunday.native.css_value('color')
    initial_monday_color = monday.native.css_value('color')
    sunday.click
    # sunday text color should change, monday should stay the same
    assert_not_equal(sunday.native.css_value('color'), initial_sunday_color)
    assert_equal(monday.native.css_value('color'), initial_monday_color)
    sunday.click
    # sunday text color should be initial color, monday should stay the same
    assert_equal(sunday.native.css_value('color'), initial_sunday_color)
    assert_equal(monday.native.css_value('color'), initial_monday_color)
  end

  test 'render sign in form when visiting manage user tab' do
    visit root_url
    click_link('Manage User')
    assert_selector(:xpath, "//input[@name='user[name]']")
    assert_selector(:xpath, "//input[@name='user[phone-number]']")
  end

  test 'validates phone number before submission' do
    visit root_url
    click_link('Manage User')
    fill_in('user[name]', with: 'Test')
    # submit with blank phone
    click_button('Sign In')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')

    # invalid phone number format
    fill_in('user[phone-number]', with: '12345')
    click_button('Sign In')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')
  end

  test 'validates username before submission' do
    visit root_url
    click_link('Manage User')
    click_button('Sign In')
    assert_equal(find('#name-warning').text, 'Please enter your username')
  end

  test 'renders sign in error if no user found' do
    visit root_url
    click_link('Manage User')
    # wait for form to render to avoid race condition
    assert_selector('#user-signin')
    fill_in('user[name]', with: 'Test')
    fill_in('user[phone-number]', with: '0000000000')
    click_button('Sign In')
    assert_equal(
      find('#sign-in-warning').text,
      'The information provided does not match any accounts'
    )
  end

  test 'edit user form rendered after sign in' do
    sign_in
    assert_no_selector('#user-signin')
  end

  test 'changes Mange User header after sign in' do
    sign_in
    assert_equal(
      find('#sign-in h3.text-center').text,
      'Manage your message settings'
    )
  end

  test 'renders user settings by default' do
    sign_in
    user = User.find_by(name: 'Sample', phone_number: '5551234567')
    assert_equal(
      find('#sign-in h3.text-center').text,
      'Manage your message settings'
    )
    assert_equal(find("input[name='user[name]']").value, user.name)
    assert_equal(find("input[name='user[phone-number]']").value,
                 user.phone_number)
    # checkboxes are hidden, so have to check the color of the label
    assert_equal(
      find("label[for='user-edit-monday']").native.css_value('color'),
      "rgba(51, 51, 51, 1)"
    )
    assert_equal(
      find("label[for='user-edit-tuesday']").native.css_value('color'),
      "rgba(187, 187, 187, 1)"
    )
  end

  test 'edit panel validates name before submitting' do
    sign_in
    fill_in('user[name]', with: '')
    click_button('Submit')
    assert_selector('#name-warning')
    assert_equal(find('#name-warning').text, 'Please enter your username')
  end

  test 'edit panel validates phone number before submitting' do
    sign_in
    fill_in('user[phone-number]', with: '')
    click_button('Submit')
    assert_selector('#phone-warning')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')
  end

  test 'edit panel renders submission warning on failed request' do
    sign_in
    User.find_by(name: 'Sample', phone_number: '5551234567')&.destroy # sign in then remove user
    click_button('Submit')
    assert_selector('#edit-warning')
    assert_equal(
      'There was a problem updating your settings. Try again later',
      find('#edit-warning').text
    )
  end

  test 'edit panel renders success message when update successful' do
    sign_in
    fill_in('user[name]', with: 'New name')
    click_button('Submit')
    assert_selector('#edit-success')
    assert_equal(
      find('#edit-success').text,
      'Success! Your settings have been updated!'
    )
  end

  # helpers
  def sign_in
    User.create(name: 'Sample', phone_number: '5551234567',
                monday: true, tuesday: false)
    visit root_url
    click_link('Manage User')
    assert_selector('#user-signin')
    fill_in('user[name]', with: 'Sample')
    fill_in('user[phone-number]', with: '5551234567')
    click_button('Sign In')
    # include assertion to wait for page to render
    assert_selector('#user-edit')
  end

  def sign_up(name, phone)
    visit root_url
    fill_in('user[name]', with: name)
    fill_in('user[phone-number]', with: phone)
    click_button('Submit')
  end
end
