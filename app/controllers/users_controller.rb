class UsersController < ApplicationController
  include ApplicationHelper

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation).freeze

  before_action :get_user, only: %i(show edit update destroy)
  before_action :logged_in_user, :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.all, limit: Settings.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "msg.welcome_msg"
      @user.send_activation_email
      flash[:info] = t "msg.check_email_request"
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @page, @microposts = pagy @user.microposts, items: Settings.page_10
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "msg.profile_updated"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "msg.user_deleted"
    else
      flash[:danger] = t "msg.delete_fail"
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit PERMITTED_ATTRIBUTES
  end

  def get_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "msg.not_found_user"
    redirect_to root_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t "msg.cannot_edit_this_account"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
