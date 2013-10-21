# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sesh do
    sequence(:title)  { |n| "Sesh Title #{n}" }
    author            { create(:user) }
    audio             File.new(Rails.root + 'spec/factories/paperclip/test_audio.mp3')
  end
end
