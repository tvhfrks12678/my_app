require 'rails_helper'

RSpec.describe 'Followings', type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario 'following page and followers page' do
    log_in_for_systemspec_as(user)
    create_other_user_and_follow(user)

    visit user_path(user)

    # following
    expect(user.following.empty?).to be_falsey
    expect(page).to have_selector '#following', text: user.following.count.to_s
    click_link "#{user.following.count} following"
    user.following.paginate(page: 1).each do |user|
      expect(page).to have_link user.name, href: user_path(user)
    end

    # follower
    expect(user.followers).to_not be_empty
    expect(page).to have_selector '#followers', text: user.followers.count.to_s
    click_link "#{user.followers.count} followers"
    user.followers.paginate(page: 1).each do |user|
      expect(page).to have_link user.name, href: user_path(user)
    end
  end
end
