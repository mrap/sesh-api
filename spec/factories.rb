FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "email#{n}@example.com" }
    password            "password"
    sequence(:username) { |n| "User#{n}" }
  end
end
