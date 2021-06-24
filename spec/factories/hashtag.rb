FactoryBot.define do
  factory :hashtag do
    hashname { Faker::Lorem.characters(number: 8) }
  end
end