require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "vist homepage - toggle signup form" do
    visit root_url
    # click sign up button
    click_button('Sign Me Up!')
    # see form
    assert_selector(:css, '#user-signup')
  end

  test "submit with blank name" do
    visit root_url
    click_button('Sign Me Up!')
    click_button('Submit')
    assert_equal(find('#name-warning').text, "Please enter a name")
  end

  test "submit with blank email" do
    visit root_url
    click_button('Sign Me Up!')
    click_button('Submit')
    assert_equal(find('#email-warning').text, "Please enter a valid email")
  end

  test "submit with invalid email" do
    visit root_url
    click_button('Sign Me Up!')
    fill_in("user[email]", with: "invalid email")
    click_button('Submit')
    assert_equal(find('#email-warning').text, "Please enter a valid email")
  end

  test "submit with blank phone number" do
    visit root_url
    click_button('Sign Me Up!')
    click_button('Submit')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')
  end

  test "submit with invalid phone number" do
    visit root_url
    click_button('Sign Me Up!')
    fill_in("user[phone-number]", with: "1234")
    click_button('Submit')
    assert_equal(find('#phone-warning').text, 'Please enter a valid phone number')
  end

  test "renders spinner on form submit" do
    visit root_url
    click_button('Sign Me Up!')
    fill_in("user[name]", with: "Me")
    fill_in("user[email]", with: "valid@email.com")
    fill_in("user[phone-number]", with: "(555) 123-4567")
    click_button('Submit')
    assert_selector(".sk-fading-circle")
  end
end
