class SessionsController < ApplicationController
  include ApplicationHelper
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      reset_session
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_to user, status: :see_other
    else
      flash.now[:danger] = t "msg.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy; end
end
