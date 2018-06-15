class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Successfully signed up! You should recieve your first joke shortly!"
      redirect_to root_path
    else
      flash[:alert] = "There was an error signing up :/"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone_number)
  end
end
