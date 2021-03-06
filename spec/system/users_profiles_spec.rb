require 'rails_helper'

RSpec.describe 'UsersProfiles', type: :system do
  include ApplicationHelper
  let(:user) { FactoryBot.create(:user) }

  scenario 'プロフィールの表示' do
    50.times do
      FactoryBot.create(:micropost, user: user)
      FactoryBot.create(:user)
    end

    users = User.all
    following = users[2..50]
    followers = users[3..40]
    following.each { |followed| user.follow(followed) }
    followers.each { |follower| follower.follow(user) }

    visit user_path(user)
    expect(page.title).to eq full_title(user.name)
    expect(page.body).to have_selector 'h1', text: user.name
    expect(page.has_selector?('h1>img.gravatar')).to be_truthy
    expect(page.body).to include(user.microposts.count.to_s)
    expect(page.has_selector?('div.pagination')).to be_truthy
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page.body).to include(micropost.content)
    end

    expect(page).to have_selector "a[href='/users/#{user.id}/following']", text: '49'
    expect(page).to have_selector "a[href='/users/#{user.id}/followers']", text: '38'
  end
end
