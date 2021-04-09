class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    return log_in_success(user) if user&.authenticate(params[:session][:password])

    log_in_failure
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

  def log_in_failure
    flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
end
