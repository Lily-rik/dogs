require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '10文字以下であること: 11文字は×' do
        user.name = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end

    context 'user_nameカラム' do
      it '空欄でないこと' do
        user.user_name = ''
        is_expected.to eq false
      end
      it '5文字以下であること: 6文字は×' do
        user.user_name = Faker::Lorem.characters(number: 6)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.user_name = other_user.user_name
        is_expected.to eq false
      end
    end

    context 'telephone_numberカラム' do
      it '空欄でないこと' do
        user.telephone_number = ''
        is_expected.to eq false
      end
      it '10文字以上であること: 9文字は×' do
        user.telephone_number = Faker::Lorem.characters(number: 9)
        is_expected.to eq false
      end
      it '11文字以下であること: 12文字は×' do
        user.telephone_number = Faker::Lorem.characters(number: 12)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        user.email = other_user.email
        is_expected.to eq false
      end
    end
  end


  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'UserRoomモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:user_rooms).macro).to eq :has_many
      end
    end
    context 'Chatモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:chats).macro).to eq :has_many
      end
    end


    # followのアソシエーション？



  end
end