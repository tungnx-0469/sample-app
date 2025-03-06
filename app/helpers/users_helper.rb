module UsersHelper
  def gravatar_for user, options = {size: Settings.default_avatar_size}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = Settings.gravatar_url << "/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: Settings.gravatar
  end
end
