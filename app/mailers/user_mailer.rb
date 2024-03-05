class UserMailer < ApplicationMailer
  def verify_email(user, verification_link)
    @user = user
    @verification_link = verification_link
    mail(to: @user.email, subject: 'Verify your email address')
  end
end
