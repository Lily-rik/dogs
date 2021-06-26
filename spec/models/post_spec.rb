require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let!(:post) { build(:post, user_id: user.id) }

    context 'imageカラム' do
      it '空欄でないこと' do
        post.image = ''
        is_expected.to eq false
      end
    end

    context 'captionカラム' do
      it '空欄でないこと' do
        post.caption = ''
        is_expected.to eq false
      end
      it '200文字以下であること: 201文字は×' do
        post.caption = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'PostHashtagモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_hashtags).macro).to eq :has_many
      end
    end
    context 'Hashtagモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:hashtags).macro).to eq :has_many
      end
    end
  end
end