class SessionsController < ApplicationController
  include ApplicationHelper
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      if user.activated?
        handle_valid_login user
      else
        flash[:warning] = t "msg.unactivated_account"
        redirect_to root_url, status: :see_other
      end
    else
      flash.now[:danger] = t "msg.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  private
  def handle_valid_login user
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
    redirect_to forwarding_url || user
  end
end
