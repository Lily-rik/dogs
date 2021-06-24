FactoryBot.define do
  factory :post do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/dogs_icon.jpg")) }
    caption { Faker::Lorem.characters(number: 30) }
    user
  end
end
