require 'rails_helper'

describe 'ユーザーログイン後のテスト：users_controller' do
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
        expect(page).to have_button ''
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
      it 'Introductionと表示される' do
        expect(page).to have_content 'Introduction'
      end
      it 'ユーザーの自己紹介が表示される' do
        expect(page).to have_content user.self_introduction
      end
      it 'Postsと表示される' do
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

  describe 'ユーザー情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it 'Information editと表示される' do
        expect(page).to have_content 'Information edit'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'telephone_numberフォームが表示される' do
        expect(page).to have_field 'user[telephone_number]'
      end
      it 'UPDATEボタンが表示される' do
        expect(page). to have_button 'UPDATE'
      end
      it '退会リンクが表示される:左上から６番目のリンクがログインである' do
        unsubscribe_link = find_all('a')[6].native.inner_text
        expect(unsubscribe_link).to match(/退会/i)
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }

      it '退会を押すと退会画面に遷移する' do
        click_link 'withdraw-btn'
        is_expected.to eq '/users/' + user.id.to_s + '/unsubscribe'
      end
    end
  end

  describe 'マイページ情報編集画面のテスト' do
    before do
      visit edit_mypage_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/mypage/' + user.id.to_s + '/edit'
      end
      it 'My page editと表示される' do
        expect(page).to have_content 'My page edit'
      end
      it 'user_nameフォームが表示される' do
        expect(page).to have_field 'user[user_name]'
      end
      it 'Self introductionフォームが表示される' do
        expect(page).to have_field 'user[self_introduction]'
      end
      it 'UPDATEボタンが表示される' do
        expect(page). to have_button 'UPDATE'
      end
    end
  end

  describe '退会画面のテスト' do
    before do
      visit unsubscribe_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/unsubscribe'
      end
      it '退会しますか？と表示される' do
        expect(page).to have_content '退会しますか？'
      end
    end
    it 'YESリンクが表示される:左上から６番目が退会するリンクである' do
      yes_link = find_all('a')[6].native.inner_text
      expect(yes_link).to match(/YES/i)
    end
    it 'NOリンクが表示される:左上から７番目が退会しないリンクである' do
      no_link = find_all('a')[7].native.inner_text
      expect(no_link).to match(/NO/i)
    end
  end

  describe 'フォロー画面のテスト' do
    before do
      visit follows_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/follows'
      end
      it "user_name's followsと表示される" do
        expect(page).to have_content "#{user.user_name}'s follows"
      end
    end
  end

  describe 'フォロワー画面のテスト' do
    before do
      visit followers_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/followers'
      end
      it "user_name's followsと表示される" do
        expect(page).to have_content "#{user.user_name}'s followers"
      end
    end
  end
end
