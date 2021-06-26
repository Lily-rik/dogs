FactoryBot.define do # 宣言文、データの定義を行う際に記述する
  factory :user do # どのモデルに対してデータ定義を行うのか記述する
    name { Faker::Lorem.characters(number: 5) }
    user_name { Faker::Lorem.characters(number: 5) }
    telephone_number { "0#{rand(0..9)}0#{rand(1_000_000..99_999_999)}" } # rand:擬似乱数を発生させる
    # 1,3桁目が0, 全部で10-11桁の電話番号を作成する
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/dogs_icon.jpg")) }
    self_introduction { Faker::Lorem.characters(number: 20) }
  end
end
