require 'rails_helper'

describe 'ユーザーログイン後のテスト：homes_controller' do
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


  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認(URLは”ログイン前のトップ画面のテスト”でテスト済み)' do
      it 'YOUR DOGSリンクが表示される：上から３番目のリンクがYOUR DOGSである' do
        yourdogs_link = find_all('a')[6].native.inner_text
        expect(yourdogs_link).to match(/YOUR DOGS/i)
      end
    end

    context  'リンク内容を確認' do
      it 'YOUR DOGSリンクの内容が正しい' do
        yourdogs_link = find_all('a')[6].native.inner_text
        expect(page).to have_link yourdogs_link, href: about_path
      end
    end
  end


  describe 'みんなの投稿画面のテスト' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/homes/about'
      end
      it 'New Postsと表示される' do
        expect(page).to have_content 'New Posts'
      end
      it 'Searchフォームが表示される' do
        expect(page).to have_field 'search'
      end
      it 'プロフィール画像が表示される：自分と他人の合計2つ存在する' do
        expect(page.all(".attachment.user.image").length).to eq 2
      end
      it '自分と他人のユーザー名リンクが表示される' do
        expect(page).to have_content user.user_name
        expect(page).to have_content other_user.user_name
      end
      it '投稿稿画像が表示される：自分と他人の合計2つ存在する
      ' do
        expect(page.all(".attachment.post.image").length).to eq 2
      end
      it '自分と他人の投稿文章が表示される' do
        expect(page).to have_content post.caption
        expect(page).to have_content other_post.caption
      end
    end

    context 'リンクを確認' do
      it '自分と他人のユーザー名のリンク先が正しい' do
        expect(page). to have_link '', href: user_path(post.user)
        expect(page). to have_link '', href: user_path(other_post.user)
      end
      it '自分と他人の投稿画像のリンク先が正しい' do
        expect(page). to have_link '', href: post_path(post)
        expect(page). to have_link '', href: post_path(other_post)
      end
    end

    context 'いいね機能の確認' do
      it '他人の投稿にいいねをつけることができる' do
        find_all('.far')[1].click
        expect(page).to have_css '.fas'
        expect(page).to have_css "div#favorite_button_#{other_post.id}"
      end
      it '他人の投稿にいいねを取り消すことができる' do
        find_all('.far')[1].click
        find_all('.fas')[1].click
        expect(page).to have_css '.far'
        expect(page).to have_css "div#favorite_button_#{other_post.id}"
      end
    end
  end
end



