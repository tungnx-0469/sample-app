class MicropostsController < ApplicationController
  include ApplicationHelper
  
  PERMITTED_ATTRIBUTES = %i(content image).freeze

  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "msg.micropost_created"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed, items: Settings.page_10
      render "statis_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "msg.micropost_deleted"
    else
      flash[:danger] = t "msg.delete_fail"
    end
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit PERMITTED_ATTRIBUTES
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "msg.micropost_invalid"
    redirect_to request.referer || root_url
  end
end
