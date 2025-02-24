class User < ApplicationRecord
  before_save :downcase_email

  validates :email, presence: true,
                    length: {maximum: Settings.user_email_max_length},
                    format: {with: Settings.valid_email_regex},
                    uniqueness: {case_sensitive: false}
  validates :name,  presence: true,
                    length: {maximum: Settings.user_name_max_length}
  validates :password, presence: true,
                       length: {minimum: Settings.user_password_min_length}

  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
