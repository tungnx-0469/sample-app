class PasswordResetsController < ApplicationController
  include ApplicationHelper

  PERMITTED_ATTRIBUTES = %i(password password_confirmation).freeze

  before_action :load_user, :valid_user,
                :check_expiration, only: %i(edit update)
  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "msg.reset_password_email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "msg.email_address_not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if user_params[:password].empty?
      flash[:warning] = t "msg.new_password_required"
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "msg.reset_password_success"
      redirect_to @user
    else
      render :edit, :unprocessable_entity
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "msg.not_found_user"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "msg.inactived_user"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit PERMITTED_ATTRIBUTES
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "msg.password_reset_expired"
    redirect_to new_password_reset_url
  end
end
