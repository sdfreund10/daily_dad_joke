# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'create saves user with valid params' do
    params = {
      'name' => 'Test',
      'phone_number' => '0123456789',
      'sunday' => true,
      'monday' => true,
      'tuesday' => true,
      'wednesday' => true,
      'thursday' => true,
      'friday' => true,
      'saturday' => true
    }
    assert_changes -> { User.count }, 1 do
      post users_url, params: { user: params }
    end
  end

  test 'create returns 422 w/ errors for invalid params' do
    params = {
      'name' => nil,
      'phone_number' => nil,
      'sunday' => true,
      'monday' => true,
      'tuesday' => true,
      'wednesday' => true,
      'thursday' => true,
      'friday' => true,
      'saturday' => true
    }
    assert_no_changes -> { User.count } do
      post users_url, params: { user: params }
    end

    assert_response 422
    body = JSON.parse(response.body)
    assert_equal(
      body,
      body.merge('phone_number' => ['is invalid'])
    )
  end
end
