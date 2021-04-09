require 'rails_helper'

RSpec.describe 'UsersEdits', type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario '編集が失敗する' do
    log_in_user_for_systemspec(email: user.email, password: user.password)
    edit_user_process(name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar')

    aggregate_failures do
      expect(current_path).to eq user_path(user)
      user.reload
      expect(user.password).to_not eq 'foo'
      expect(page.body).to have_selector '#error_explanation', text: 'Name'
      expect(page.body).to have_selector '#error_explanation', text: 'Email'
      expect(page.body).to have_selector '#error_explanation', text: 'Password'
      expect(page.body).to have_selector '#error_explanation', text: 'Password confirmation'
    end
  end

  scenario 'フレンドリーフォワーディングして、編集の成功' do
    visit edit_user_path(user)
    log_in_user_for_systemspec(email: user.email, password: user.password)
    expect(current_path).to eq edit_user_path(user)
    visit root_path
    expect(current_path).to_not eq edit_user_path(user)
    edit_user_process(name: 'yamada', email: 'yamada@example.com', password: '', password_confirmation: '')
    aggregate_failures do
      expect(current_path).to eq user_path(user)
      user.reload
      expect(user.name).to eq 'yamada'
      expect(user.email).to eq 'yamada@example.com'
      expect(page.body).to have_selector '.alert-success'
    end
  end

  def edit_user_process(name:, email:, password:, password_confirmation:)
    click_link 'Setting'
    expect(current_path).to eq edit_user_path(user)
    fill_in 'user_name',	with: name
    fill_in 'user_email',	with: email
    fill_in 'user_password',	with: password
    fill_in 'user_password_confirmation', with: password_confirmation
    click_button 'Save change'
  end
end
