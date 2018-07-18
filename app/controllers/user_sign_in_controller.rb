# frozen_string_literal: true

class UserSignInController < ApplicationController
  def create
    user = User.find_by(user_params)
    if user.nil?
      render(
        json: 'No user found with given username and phone number', status: 422
      )
    else
      render(
        json: user.attributes.except('id', 'created_at', 'updated_at'),
        status: 200
      )
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number)
  end
end
