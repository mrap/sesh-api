# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    sesh                { create(:sesh) }
    user                { create(:user) }
    sequence(:content)  { |n| "This is comment ##{n}" }
  end
end
