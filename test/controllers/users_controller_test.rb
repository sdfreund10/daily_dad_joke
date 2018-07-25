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

  test "update renders 500 when not passed find params" do
    request = { params: {
      user: { name: "New Name", phone_number: "0123456789" }
    } }

    assert_raise ActionController::ParameterMissing do
      patch users_url, request
    end
  end

  test "it returns 400 when user not found" do
    request = { params: {
      find_params: { name: "Test", phone_number: "0123456789" },
      user: { name: "New Name", phone_number: "0123456789" }
    } }
    patch users_url, request
    assert_response 400
    assert_equal(
      response.body,
      "User not found"
    )
  end

  test "it returns 200 and updates user on success" do
    user = User.create(name: "Test", phone_number: "0123456789")
    request = { params: {
      find_params: { name: "Test", phone_number: "0123456789" },
      user: { name: "New Name", phone_number: "0123456789" }
    } }

    patch users_url, request
    assert_response 200

    user.reload
    assert_equal("New Name", user.name)
  end

  test "destroy deletes users by find_params" do
    user = User.create(name: "Test", phone_number: "0123456789")
    request = { params: {
      find_params: { name: "Test", phone_number: "0123456789" }
    } }
    assert_changes(-> { User.count }, 1) { delete users_url, request }
    assert_response 200
  end

  test "destroy render no user found if find params not valid" do
    request = { params: {
      find_params: { name: "Test", phone_number: "0123456789" }
    } }
    assert_no_changes(-> { User.count }) { delete users_url, request }
    assert_response 400
    assert_equal(
      response.body,
      "User not found"
    )
  end
end
