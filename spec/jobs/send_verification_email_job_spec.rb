require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe SendVerificationEmailJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'sends a verification email' do
      expect {
        SendVerificationEmailJob.new.perform(user.id, "https://blog.com/verification-link")
      }.to change { ActionMailer::Base.deliveries.count }.by(1)

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([user.email])
      expect(email.subject).to eq('Verify your email address')
    end
  end
end