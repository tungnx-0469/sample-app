module ApplicationHelper
  include SessionsHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_title = t "base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
