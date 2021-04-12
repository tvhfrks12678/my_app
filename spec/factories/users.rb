FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "tarou-#{n}" }
    sequence(:email) { |n| "tarou#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    activated { true }
    activated_at { Time.zone.now }
  end
end
