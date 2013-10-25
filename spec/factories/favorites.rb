# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favorite do
    favoriter  { create(:user) }
    favorited  { create(:sesh) }
  end
end
