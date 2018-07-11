# frozen_string_literal: true

require 'test_helper'

class ErrorControllerTest < ActionDispatch::IntegrationTest
  test 'show raises and error' do
    assert_raises(RuntimeError) do
      get '/error'
    end
  end
end
