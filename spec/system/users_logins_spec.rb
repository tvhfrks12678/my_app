require 'rails_helper'

RSpec.describe 'UsersLogins', type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario 'メールが正しくて、パスワードが誤っている情報でログインする' do
    visit login_path
    log_in_user(email: user.email, password: '')
    aggregate_failures do
      expect(current_path).to eq login_path
      expect_display_log_in_error
    end
  end

  scenario 'メールとパスワードが誤っている情報でログインする' do
    visit login_path
    log_in_user(email: 'a@a', password: '')
    aggregate_failures do
      expect(current_path).to eq login_path
      expect_display_log_in_error
    end
  end

  scenario '有効な情報でログインして、ログアウトする' do
    visit login_path
    log_in_user(email: user.email, password: user.password)
    aggregate_failures do
      expect(current_path).to eq user_path(user)
      expect_display_log_in(user)
    end
    click_link 'Log out'
    aggregate_failures do
      expect(current_path).to eq root_path
      expect_display_log_out
    end
  end

  def log_in_user(email:, password:)
    fill_in 'session_email',	with: email
    fill_in 'session_password',	with: password
    click_button 'Log in'
  end

  def expect_display_log_in_error
    expect(page).to have_selector '.alert-danger', text: 'Invalid email/password combination'
    visit root_path
    expect(page).to_not have_selector '.alert-danger', text: 'Invalid email/password combination'
  end

  def expect_display_log_in(user)
    expect(page).to_not have_link 'Log in'
    expect(page).to have_link 'Log out'
    expect(page).to have_link 'Profile', href: user_path(user)
  end

  def expect_display_log_out
    expect(page).to have_link 'Log in'
    expect(page).to_not have_link 'Log out'
    expect(page).to_not have_link 'Profile'
  end
end
