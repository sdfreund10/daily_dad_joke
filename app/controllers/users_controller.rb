# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: 200
    else
      render json: @user.errors, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number, :sunday, :monday,
                                 :tuesday, :wednesday, :thursday, :friday,
                                 :saturday)
  end
end
