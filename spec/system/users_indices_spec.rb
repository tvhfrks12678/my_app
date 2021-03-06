require 'rails_helper'

RSpec.describe 'UsersIndices', type: :system do
  before do
    @admin_user = FactoryBot.create(:user, admin: true)
    @no_admin_user = FactoryBot.create(:user, admin: false)
    @not_activated_user = FactoryBot.create(:user, activated: false)
    35.times do
      FactoryBot.create(:user)
    end
  end

  scenario 'Usersページにpaginationが設定されている' do
    log_in_user_for_systemspec(email: @admin_user.email, password: @admin_user.password)
    click_link 'Users'
    expect(current_path).to eq users_path
    expect(page).to have_css '.pagination'
    expect(page.all('div.pagination').length).to eq 2
    expect(page.body).to_not have_link @not_activated_user.name, href: user_path(@not_activated_user)

    User.where(activated: true).paginate(page: 1).each do |user_info|
      expect(page.body).to have_link 'delete', href: user_path(user_info) unless user_info == @admin_user

      expect(page.body).to have_link user_info.name, href: user_path(user_info)
    end

    expect do
      click_link 'delete', href: user_path(@no_admin_user)
    end.to change(User, :count).by(-1)
  end

  scenario '管理者権限がないユーザーでログインした時、削除リンクが表示されない' do
    log_in_user_for_systemspec(email: @no_admin_user.email, password: @no_admin_user.password)
    click_link 'Users'
    expect(page).to_not have_selector 'a[data-method=delete]', text: 'delete'
  end
end
