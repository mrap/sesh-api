# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "User#{n}" }
    sequence(:email)    { |n| "#{username}@example.com" }
    password            "password"
  end
end
