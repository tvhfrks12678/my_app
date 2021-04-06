class UsersController < ApplicationController
  MG_USER_REGISTRATION_SUCCESS = 'Welcome to the Sample App!'.freeze

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = MG_USER_REGISTRATION_SUCCESS
      return redirect_to @user
    end
    render 'new'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
