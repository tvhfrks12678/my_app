FactoryBot.define do
  factory :micropost do
    sequence(:content) { |n| "post-No.#{n}" }
    association :user
    # cotent { 'MyText' }
    # user { nil }
  end
end
