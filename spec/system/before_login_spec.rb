require 'rails_helper'


describe 'ユーザーログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do  # itの処理をする前に行う処理
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'SIGN UPリンクが表示される:　左上から3番目のリンクがSIGN UPである' do
        sign_up_link = find_all('a')[3].native.inner_text
                       # 要素に指定されているclassやtextなどの確認が行える
                       # 上記では３番目のaタグの中にあるtextを見つけてきている
        expect(sign_up_link).to match(/SIGN UP/i)
                                # 上記で見つけたtextがSIGN UPとマッチするか確認している
                                # i=3を表している
      end
      it 'SIGN UPリンクの内容が正しい' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it 'LOG INリンクが表示される:　左上から４番目のリンクがLOG INである' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match(/LOG IN/i)
      end
      it 'LOG INリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
    end
  end


  describe 'ヘッダーのテスト：　ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it '新規登録リンクが表示される:　左上から１番目のリンクが新規登録である' do
        sign_up_link = find_all('a')[1].native.inner_text
        expect(sign_up_link).to match(/SIGN UP/i)
      end
      it 'ログインリンクが表示される:　左上から２番目のリンクがログインである' do
        log_in_link = find_all('a')[2].native.inner_text
        expect(log_in_link).to match(/LOG IN/i)
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }

      it 'SIGN UPを押すと新規登録画面に遷移する' do
        click_link 'nav-link8' # リンクのクリック 'クリックしたいnameかidを入れる'
        is_expected.to eq '/users/sign_up'
      end
      it 'LOG INを押すとログイン画面に遷移する' do
        click_link 'nav-link9'
        is_expected.to eq '/users/sign_in'
      end
    end
  end


  describe 'ユーザー新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it 'Sign upと表示される' do
        expect(page).to eq have_content 'Sign up'  # 文字列が存在するか
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'  # 入力フォームが存在するか 'モデル名/カラム名'
      end
      it 'user_nameフォームが表示される' do
        expect(page).to have_field 'user[user_name]'
      end
      it 'telephone_numberフォームが表示される' do
        expect(page).to have_field 'user[telephone_number]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'SIGNUPボタンが表示される' do
        expect(page). to have_button 'SIGN UP'  # ページ上に指定のボタンが存在するか
      end
    end

  end

  context '新規登録成功のテスト' do
    before do
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 5)  # nameかidを入力する
      fill_in 'user[user_name]', with: Faker::Lorem.characters(number: 5)
      fill_in 'user[telephone_number]',with: "0#{rand(0..9)}0#{rand(1_000_000..99_999_999)}"
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end
    it '正しく新規登録される' do
      expect { click_button 'SIGN UP' }.to change(User.all, :count).by(1)  # クリックボタンを押すとUserモデルのデータカウントが１増える
    end
    it '新規登録後のリダイレクト先がみんなの投稿(home/about)画面になっている' do
      click_button 'SIGN UP'
      expect(current_path).to eq '/homes/about'
    end
  end








end





#signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
                        # gsubメソッドは文字列の置換を行なっている
                        # \n(改行)、\A,\z(文字列の先頭,末尾)、\s(半角スペース、タブ、改行のどれか1文字)、*(直前の文字の0回以上の繰り返し)
                        # 上記が''(空白)に置換される
