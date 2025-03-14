class AccountActivationsController < ApplicationController
  include ApplicationHelper
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "msg.account_activated"
      redirect_to user
    else
      flash[:danger] = t "msg.invalid_activation_link"
      redirect_to root_url
    end
  end
end
