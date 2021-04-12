class AccountActivationsController < ApplicationController
  MSG_VALID_ACCOUNT = 'Account activated!'.freeze
  MSG_INVALID_ACCOUNT = 'invalid activation link'.freeze
  def edit
    user = User.find_by(email: params[:email])

    return display_invalid_activation unless user && !user.activated? && user.authenticated?(:activation, params[:id])

    user.activate
    log_in user
    display_valid_activation(user)
  end

  def display_valid_activation(user)
    flash[:success] = MSG_VALID_ACCOUNT
    redirect_to user
  end

  def display_invalid_activation
    flash[:danger] = MSG_INVALID_ACCOUNT
    redirect_to root_url
  end
end
