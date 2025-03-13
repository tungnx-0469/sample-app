class StatisPagesController < ApplicationController
  include ApplicationHelper
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, items: Settings.page_10
  end

  def help; end
end
