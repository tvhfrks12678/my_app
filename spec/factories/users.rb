FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "tarou-#{n}" }
    sequence(:email) { |n| "tarou#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
