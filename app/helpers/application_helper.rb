module ApplicationHelper
  include SessionsHelper
  
  def full_title page_title = ""
    base_title = t "base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
