require 'rails_helper'

RSpec.describe 'MicropostInterfaces', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  before do
    35.times do
      FactoryBot.create(:micropost, user: user)
    end
  end

  scenario 'マイクロポストのUI' do
    log_in_user_for_systemspec(email: user.email, password: user.password)
    visit root_path
    expect(page.body).to have_selector('div.pagination')
    # 無効な送信
    expect do
      post_micropost('')
      expect(page).to have_selector('div#error_explanation')
      expect(page).to have_selector('a[href="/?page=2"]')
      expect(page).to have_selector('input[type="file"]')
    end.to_not change(Micropost, :count)
    # 有効な送信
    content = 'This micropost really ties the room together'
    expect do
      attach_file 'micropost_image', Rails.root.join('spec/fixtures/image/kitten.jpg')
      post_micropost(content)
      expect(current_url).to eq root_url
      expect(page).to have_content content
      id = user.microposts.paginate(page: 1).first.id
      expect(find("li#micropost-#{id}").native.to_s).to match('kitten.jpg')
    end.to change(Micropost, :count).by(1)
    # 投稿を削除する
    expect(page).to have_selector 'a', text: 'delete'
    expect do
      id = user.microposts.paginate(page: 1).first.id
      find("li#micropost-#{id}").click_link 'delete'
      expect(page).to_not have_content content
    end.to change(Micropost, :count).by(-1)
    # 違うユーザーのプロフィールにアクセス(削除リングがないことを確認)
    visit user_path(other_user)
    expect(page).to have_selector('a'), text: 'delete'
  end

  scenario 'サイドバーのマイクロポストの表示数' do
    log_in_user_for_systemspec(email: user.email, password: user.password)
    visit root_path
    expect(find('.user_info').native.to_s).to include "#{user.microposts.count} microposts"
    # まだマイクロポストを投稿していないユーザー
    click_link 'Log out'
    log_in_user_for_systemspec(email: other_user.email, password: other_user.password)
    visit root_path
    expect(find('.user_info').native.to_s).to include '0 microposts'
    post_micropost('A micropost')
    expect(find('.user_info').native.to_s).to include '1 micropost'
  end

  def post_micropost(content)
    fill_in 'micropost_content',	with: content
    click_button 'Post'
  end
end
