class PasswordResetsController < ApplicationController
  before_action :attribute_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions.'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found.'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      return render 'edit'
    end
    return process_after_password_reset(@user) if @user.update(user_params)

    render 'edit'
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # beforeフィルタ

  def attribute_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  # トークンが期限切れかどうか確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end

  # パスワードリセット後の処理
  def process_after_password_reset(user)
    log_in user
    user.update_attribute(:reset_digest, nil)
    flash[:success] = 'Password has been reset.'
    redirect_to user
  end
end
