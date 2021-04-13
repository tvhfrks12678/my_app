require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, reset_token: User.new_token) }

  describe 'account_activation' do
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      aggregate_failures do
        expect(mail.subject).to eq('Account activation')
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(['noreply@example.com'])
      end
    end

    it 'renders the body' do
      user.activation_token = User.new_token
      aggregate_failures do
        expect(mail.body.encoded).to match('Hi')
        expect(mail.body.encoded).to match(user.name)
        expect(mail.body.encoded).to match(user.activation_token)
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
    end
  end

  describe 'password_reset' do
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      aggregate_failures do
        expect(mail.subject).to eq('Password reset')
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(['noreply@example.com'])
      end
    end

    it 'renders the body' do
      # user.reset_token = User.new_token
      aggregate_failures do
        expect(mail.body.encoded).to match('To reset your')
        expect(mail.body.encoded).to match(user.reset_token)
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
    end
  end
end
