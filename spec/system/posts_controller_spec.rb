require 'rails_helper'

describe 'ユーザーログイン後のテスト：posts_controller' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'LOG IN'
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it "user_name's dogと表示される" do
        expect(page).to have_content "#{user.user_name}'s dog"
      end
      it 'プロフィール画像が表示される：自分のプロフィール画像が1つ存在する' do
        expect(page.all(".attachment.user.image").length).to eq 1
      end
      it "ユーザーネームが表示される" do
        expect(page).to have_content "#{user.user_name}"
      end
      # it '投稿編集アイコンが表示される' do
      #   is_expected.to have_selector '.fas.fa-edit'
      # end
      # it 'いいねアイコンが表示される' do
      #   visit post_path(other_post)
      #   is_expected.to have_selector '.fas.fa-heart'
      # end
      it '投稿画像が表示される：自分の投稿画像が1つ存在する' do
        expect(page.all(".attachment.post.image").length).to eq 1
      end
      it '投稿文章が表示される' do
        expect(page).to have_content post.caption
      end
      it "Comments(0)と表示される" do
        expect(page).to have_content "Comments(0)"
      end
      it "New Commentと表示される" do
        expect(page).to have_content "New Comment"
      end
      it 'commentフォームが表示される' do
        expect(page).to have_field 'comment[comment]'
      end
      it 'UPDATEボタンが表示される' do
        expect(page). to have_button 'COMMENT'
      end
    end
  end


  describe '投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it 'Post editと表示される' do
        expect(page).to have_content 'Post edit'
      end
      it 'Post imageと表示される' do
        expect(page).to have_content 'Post image'
      end
      it 'Post textと表示される' do
        expect(page).to have_content 'Post text'
      end
      it 'captionフォームが表示される' do
        expect(page).to have_field 'post[caption]'
      end
      it 'UPDATEボタンが表示される' do
        expect(page). to have_button 'UPDATE'
      end
      it 'DESTROYリンクが表示される：左上から６番目のリンクがCHATである' do
        destroy_link = find_all('a')[6].native.inner_text
        expect(destroy_link).to match(/DESTROY/i)
      end
    end
  end


  describe 'ランキング画面のテスト' do
    before do
      visit ranking_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/ranking'
      end
      it "Rankingと表示される" do
        expect(page).to have_content "Ranking"
      end
    end
  end


  # describe 'ハッシュタグ画面のテスト' do
  #   before do
  #     visit hashtag_path(hashname)
  #   end

  #   context '表示内容の確認' do
  #     it 'URLが正しい' do
  #       expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
  #     end
  #     it 'Post editと表示される' do
  #       expect(page).to have_content 'Post edit'
  #     end
  #   end
  # end




end