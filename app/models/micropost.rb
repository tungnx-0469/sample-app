class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: Settings.image_size
  end

  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: Settings.allowed_image_file_type,
                                   message: I18n.t("msg.invalid_image_format")},
                    size: {less_than: Settings.max_file_size.megabytes,
                           message: I18n.t("msg.invalid_file_size")}

  scope :recent_posts, ->{order created_at: :desc}
end
