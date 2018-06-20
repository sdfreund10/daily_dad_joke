class UsersController < ApplicationController
  def create
    sleep 1
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: 200
    else
      render json: @user.errors, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone_number)
  end
end
