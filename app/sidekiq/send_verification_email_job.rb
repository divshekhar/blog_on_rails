class SendVerificationEmailJob
  include Sidekiq::Job

  def perform(user_id, verification_link)
    user = User.find(user_id)
    UserMailer.verify_email(user, verification_link).deliver_now
  end
end
