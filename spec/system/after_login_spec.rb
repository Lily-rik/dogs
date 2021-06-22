require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
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


  describe 'ヘッダーのテスト：ログインしている場合' do

    context '表示内容の確認' do
      it 'MY PAGEリンクが表示される：左上から１番目のリンクがMY PAGEである' do
        mypage_link = find_all('a')[1].native.inner_text
        expect(mypage_link).to match(/MY PAGE/i)
      end
      it 'YOUR DOGSリンクが表示される：左上から２番目のリンクがYOUR DOGSである' do
        your_dogs_link = find_all('a')[2].native.inner_text
        expect(your_dogs_link).to match(/YOUR DOGS/i)
      end
      it 'RANKINGリンクが表示される：左上から３番目のリンクがRANKIGである' do
        ranking_link = find_all('a')[3].native.inner_text
        expect(ranking_link).to match(/RANKING/i)
      end
      it 'LOG OUTリンクが表示される：左上から４番目のリンクがLOG OUTである' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match(/LOG OUT/i)
      end
    end

    context 'リンク内容を確認(LOG OUTは”ユーザーログアウトのテスト”でテスト済み)' do
      subject { current_path }

      it 'ロゴを押すとトップ画面に遷移する' do
        click_link 'navbar-content-center'
        is_expected.to eq '/'
      end
      it 'MY PAGEを押すとマイページ画面に遷移する' do
        click_link 'nav-link3'
        is_expected.to eq '/users/' + user.id.to_s  # '/users/n'
      end
      it 'YOUR DOGSを押すとみんなの投稿画面に遷移する' do
        click_link 'nav-link4'
        is_expected.to eq '/homes/about'
      end
      it 'RANKINGを押すとランキング画面に遷移する' do
        click_link 'nav-link5'
        is_expected.to eq '/posts/ranking'
      end
      it '設定アイコンを押すとユーザー情報編集画面に遷移する' do
        click_link 'nav-link7'
        is_expected.to eq '/users/' + user.id.to_s + '/edit'  # 'users/n/edit'
      end
    end
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

  describe '自分のマイページ画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it "user_name's pageと表示される" do
        expect(page).to have_content "#{user.user_name}'s page"
      end
      it 'プロフィール画像が表示される：自分のプロフィール画像が1つ存在する' do
        expect(page.all(".attachment.user.image").length).to eq 1
      end
      it 'マイページ編集アイコンボタンが表示される' do
        expect(page).to have_button  ''
      end
      it 'FOLLOWリンクが表示される：左上から７番目のリンクがFOLLOWである' do
        follow_link = find_all('a')[7].native.inner_text
        expect(follow_link).to match(/FOLLOW 0/i)
      end
      it 'FOLLOWERリンクが表示される：左上から８番目のリンクがFOLLOWERである' do
        follower_link = find_all('a')[8].native.inner_text
        expect(follower_link).to match(/FOLLWER 0/i)
      end
      it 'FAVORITESリンクが表示される：左上から９番目のリンクがFAVORITESである' do
        favorites_link = find_all('a')[9].native.inner_text
        expect(favorites_link).to match(/FAVORITES/i)
      end
      it 'NEW POSTリンクが表示される：左上から１０番目のリンクがNEW POSTである' do
        new_post_link = find_all('a')[10].native.inner_text
        expect(new_post_link).to match(/NEW POST/i)
      end
      it "Introductionと表示される" do
        expect(page).to have_content 'Introduction'
      end
      it "Introductionと表示される" do
        expect(page).to have_content user.self_introduction
      end
      it "Postsと表示される" do
        expect(page).to have_content 'Posts'
      end
      it '投稿画像が表示される：自分の投稿画像が1つ存在する' do
        expect(page.all(".attachment.post.image").length).to eq 1
      end
      it '投稿文章が表示される' do
        expect(page).to have_content post.caption
      end
    end
  end
  
  describe '他人のマイページ画面のテスト(自分のマイページと表示が異なる箇所のみテストする)' do
    before do
      visit user_path(other_user)
    end
    
    context '表示内容の確認' do
      it 'FOLLOWボタンが表示される：左上から６番目のボタンがFOLLOWである' do
        follow_button = find_all('a')[6].native.inner_text
        expect(follow_button).to match(/FOLLOW/i)
      end
      it 'CHATリンクが表示される：左上から１０番目のリンクがCHATである' do
        chat_link = find_all('a')[10].native.inner_text
        expect(chat_link).to match(/CHAT/i)
      end
    end
  end














end



