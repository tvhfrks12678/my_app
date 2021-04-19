module SystemSupport
  def create_other_user_and_follow(user)
    50.times do
      FactoryBot.create(:user)
    end

    users = User.all
    following = users[2..50]
    followers = users[3..40]
    following.each { |followed| user.follow(followed) }
    followers.each { |follower| follower.follow(user) }
  end
end

RSpec.configure do |config|
  # config.include(SystemSupport, type: :system)
  config.include(SystemSupport)
end
