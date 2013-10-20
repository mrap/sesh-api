# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sesh do
    sequence(:title)  { |n| "Sesh Title #{n}" }
    author            { create(:user) }
  end
end
