# frozen_string_literal: true

require 'test_helper'

class UserSignInControllerTest < ActionDispatch::IntegrationTest
  test 'new returns 200 and user params with success' do
    user = User.create!(name: 'test', phone_number: '1234567890')
    user_params = { name: user.name, phone_number: user.phone_number }
    post user_sign_in_index_url, params: { user: user_params }
    assert_response 200
    body = JSON.parse(response.body)
    assert_equal(
      body,
      user.attributes.except('id', 'created_at', 'updated_at')
    )
  end

  test 'new returns 422 when no user found' do
    post user_sign_in_index_url, params: { user: { name: "" } }
    assert_response 422
    assert_equal(
      body,
      'No user found with given username and phone number'
    )
  end
end
