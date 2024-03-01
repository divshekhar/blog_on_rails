class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Please check your email for confirmation"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
