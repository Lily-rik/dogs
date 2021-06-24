require 'rails_helper'

RSpec.describe 'Chatモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { chat.valid? }

    let(:user) { create(:user) }
    let(:room) { create(:room) }
    let!(:chat) { build(:chat, user_id: user.id) }
    let!(:chat) { build(:chat, room_id: room.id) }

    context 'messageカラム' do
      it '空欄でないこと' do
        chat.message = ''
        is_expected.to eq false
      end
      it '100文字以下であること: 101文字は×' do
        chat.message = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end


  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Chat.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Chat.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end