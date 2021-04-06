require 'rails_helper'

RSpec.describe 'Users', type: :system do
  scenario '無効なユーザー情報を登録する' do
    visit root_path
    click_link 'Sign up now!'

    expect do
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: 'a'
      fill_in 'user_password', with: 'b'
      fill_in 'user_password_confirmation', with: 'c'
      click_button 'Create my account'

      aggregate_failures do
        expect(current_path).to eq users_path
        expect(page).to have_selector '#error_explanation', text: 'error'
        expect(page).to have_selector '.alert-danger', text: 'error'
      end
    end.to_not change(User, :count)
  end

  scenario '有効なユーザー情報を登録する' do
    visit root_path
    click_link 'Sign up now!'

    expect do
      fill_in 'user_name', with: 'tarou'
      fill_in 'user_email', with: 'tarou@example.com'
      fill_in 'user_password', with: 'foobar'
      fill_in 'user_password_confirmation', with: 'foobar'
      click_button 'Create my account'

      aggregate_failures do
        expect(current_path).to eq user_path(User.last)
        expect(page).to have_selector '.alert-success', text: 'Welcome to the Sample App!'
      end
    end.to change(User, :count).by(1)
  end
end
