class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mail.subject.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mail.subject.password_reset")
  end
end
