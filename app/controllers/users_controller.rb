# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.attributes.except('id'), status: 200
    else
      render json: @user.errors, status: 422
    end
  end

  def update
    user = User.find_by(find_params)
    if user.nil?
      render plain: "User not found", status: 400
    else
      user.update!(user_params)
      render json: user.attributes.except('id'), status: 200
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone_number, :sunday, :monday,
                                 :tuesday, :wednesday, :thursday, :friday,
                                 :saturday)
  end

  def find_params
    params.require(:find_params).permit(:name, :phone_number)
  end
end
