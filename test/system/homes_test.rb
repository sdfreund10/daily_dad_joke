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
    assert_equal(find('#name-warning').text, 'Please enter a name')
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
    visit root_url
    fill_in('user[name]', with: 'Me')
    fill_in('user[phone-number]', with: '(555) 123-4567')
    click_button('Submit')
    assert_selector('.sk-fading-circle')
  end

  test 'renders alert when user with phone-number exists' do
    User.create(name: 'Sample', phone_number: '5551234567')
    visit root_url
    fill_in('user[name]', with: 'Test')
    fill_in('user[phone-number]', with: '(555) 123-4567')
    click_button('Submit')
    wait_for_ajax
    assert_equal(
      find('#submission-warning').text,
      'That phone number is already taken'
    )
  end

  test 'renders checkmark with success message when user created' do
    visit root_url
    fill_in('user[name]', with: 'Test')
    fill_in('user[phone-number]', with: '(555) 123-4567')
    click_button('Submit')
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
    monday_color = find("label[for='monday']").native.css_value('color')
    assert_not_equal(
      find("label[for='sunday']").native.css_value('color'),
      monday_color
    )
    assert_not_equal(
      find("label[for='saturday']").native.css_value('color'),
      monday_color
    )
  end

  test 'weekday labels change color when clicked' do
    visit root_url
    sunday = find("label[for='sunday']")
    monday = find("label[for='monday']")
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
end
