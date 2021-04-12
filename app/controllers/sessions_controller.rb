class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    return log_in_failure unless user&.authenticate(params[:session][:password])

    return log_in_not_activated unless user.activated?

    log_in_success(user)
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def log_in_success(user)
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    redirect_back_to user
  end

  def log_in_not_activated
    message = 'Account not activated.'
    message += 'Check your email for the activation link.'
    flash[:warning] = message
    redirect_to root_url
  end

  def log_in_failure
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
