class UsersController < ApplicationController
  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation).freeze

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "msg.welcome_msg"
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = Settings.user_not_found_error
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit PERMITTED_ATTRIBUTES
  end
end
