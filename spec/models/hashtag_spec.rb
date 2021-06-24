require 'rails_helper'

RSpec.describe 'Hadhtagモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { hashtag.valid? }

    let(:hashtag) { create(:hashtag) }

    context 'hashnameカラム' do
      it '空欄でないこと' do
        hashtag.hashname = ''
        is_expected.to eq false
      end
      it '15文字以下であること: 16文字は×' do
        hashtag.hashname = Faker::Lorem.characters(number: 16)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(Hashtag.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'PostHashtagモデルとの関係' do
      it '1:Nとなっている' do
        expect(Hashtag.reflect_on_association(:post_hashtags).macro).to eq :has_many
      end
    end
  end
end