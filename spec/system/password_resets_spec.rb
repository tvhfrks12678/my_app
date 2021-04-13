require 'rails_helper'

RSpec.describe 'PasswordResets', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'パスワードのリセット' do
    go_to_forgot_password
    # メールアドレスが無効
    reset_password(email: 'invalid')
    expect(page).to have_selector '.alert-danger', text: 'Email address not found'
    expect(current_path).to eq password_resets_path
    # メールアドレスが有効
    reset_password(email: user.email)
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(current_path).to eq root_path
    expect(page.body).to have_selector '.alert-info', text: 'Email sent with password reset instructions.'
    # パスワード再設定フォームのテスト
    user_reset_token = attribute_reset_token_from_mail
    # メールアドレスが無効
    invalid_url = create_password_reset_url(email: '', reset_token: user_reset_token)
    visit invalid_url
    expect(current_path).to eq root_path
    # 無効なユーザー
    user.toggle!(:activated)
    url = create_password_reset_url(email: user.email, reset_token: user_reset_token)
    visit url
    expect(current_path).to eq root_path
    user.toggle!(:activated)
    # メールアドレスもトークンも有効
    url_password_reset = create_password_reset_url(email: user.email, reset_token: user_reset_token)
    visit url_password_reset
    expect(current_url).to eq url
    expect(page.title).to match 'Reset password'
    expect(find('#email', visible: false).value).to eq user.email
    # 無効なパスワードとパスワード確認
    change_password(password: 'foobaz', password_confirmation: 'bazfoo')
    expect_failed_change_password(reset_token: user_reset_token)
    # パスワードが空
    change_password(password: '', password_confirmation: '')
    expect_failed_change_password(reset_token: user_reset_token)
    # 有効なパスワードとパスワード確認
    change_password(password: 'foobaz', password_confirmation: 'foobaz')
    expect(page.body).to have_selector '.alert-success', text: 'Password has been reset.'
    expect(current_path).to eq user_path(user)
    expect(user.reload.reset_digest).to eq nil
  end

  scenario '期限切れトークン' do
    go_to_forgot_password
    reset_password(email: user.email)
    user_update_params = user.attributes
    user_update_params[:reset_sent_at] = 3.hours.ago
    user.update(user_update_params)
    user_reset_token = attribute_reset_token_from_mail
    url_password_reset = create_password_reset_url(email: user.email, reset_token: user_reset_token)
    visit url_password_reset
    expect(page.body).to match('expired')
  end

  def attribute_reset_token_from_mail
    mail_body = ActionMailer::Base.deliveries.last.html_part.body.raw_source.to_s
    mail_body.match(%r{password_resets/(.+?)/})[1]
  end

  def go_to_forgot_password
    visit root_path
    click_link 'Log in'
    click_link 'forgot password'
  end

  def reset_password(email:)
    fill_in 'password_reset_email',	with: email
    click_button 'Submit'
  end

  def create_password_reset_url(email:, reset_token:)
    "http://example.com/password_resets/#{reset_token}/edit?email=#{CGI.escape(email)}"
  end

  def change_password(password:, password_confirmation:)
    fill_in 'user_password',	with: password
    fill_in 'user_password_confirmation',	with: password_confirmation
    click_button 'Update password'
  end

  def expect_failed_change_password(reset_token:)
    expect(page).to have_selector '.alert-danger', text: 'error'
    expect(current_path).to eq password_reset_path(reset_token)
  end
end
