class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "msg.please_log_in."
    redirect_to login_url
  end
end
