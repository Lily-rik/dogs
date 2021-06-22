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
      it "Welcome to DOG'Sと表示される" do
        expect(page).to have_content "Welcome to DOG'S"
      end
      it 'SIGN UPリンクが表示される:左上から3番目のリンクがSIGN UPである' do
        sign_up_link = find_all('a')[3].native.inner_text
                       # 要素に指定されているclassやtextなどの確認が行える
                       # 上記では３番目のaタグの中にあるtextを見つけてきている
        expect(sign_up_link).to match(/SIGN UP/i)
                                # 上記で見つけたtextがSIGN UPとマッチするか確認している
                                # i=3を表している
      end
      it 'LOG INリンクが表示される:左上から４番目のリンクがLOG INである' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match(/LOG IN/i)
      end
    end

    context 'リンク内容を確認' do
      it 'SIGN UPリンクの内容が正しい' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it 'LOG INリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
    end

  end


  describe 'ヘッダーのテスト：ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'SIGN UPリンクが表示される:左上から１番目のリンクが新規登録である' do
        sign_up_link = find_all('a')[1].native.inner_text
        expect(sign_up_link).to match(/SIGN UP/i)
      end
      it 'LOG INリンクが表示される:左上から２番目のリンクがログインである' do
        log_in_link = find_all('a')[2].native.inner_text
        expect(log_in_link).to match(/LOG IN/i)
      end
    end

    context 'リンク内容を確認' do
      subject { current_path } # 対象

      it 'ロゴを押すとトップ画面に遷移する' do
        click_link 'navbar-content-center'
        is_expected.to eq '/'
      end
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
        expect(page).to have_content 'Sign up'  # 文字列が存在するか
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
      it 'SIGN UPボタンが表示される' do
        expect(page). to have_button 'SIGN UP'  # ページ上に指定のボタンが存在するか
      end
      it 'LOG INリンクが表示される:上から３番目のリンクがログインである' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(log_in_link).to match(/LOG IN/i)
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }
      it 'LOG INを押すとログイン画面に遷移する' do
        click_link 'log-in-btn'
        is_expected.to eq '/users/sign_in'
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
      it '新規登録後のリダイレクト先がみんなの投稿画面になっている' do
        click_button 'SIGN UP'
        expect(current_path).to eq '/homes/about'
      end
    end

    context '新規登録失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[user_name]', with: ''
        fill_in 'user[telephone_number]',with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button 'SIGN UP'
      end
      it '新規登録に失敗し、新規登録画面にリダイレクトされる' do
        expect(current_path).to eq '/users'
      end
    end
  end


  describe 'ユーザーログイン' do
    let(:user) { create(:user) }  # @user = user.createと同じ意味
                                  # letはインスタンス変数やローカル変数をletという機能で置き換えることができる
    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'Log inと表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'LOG INボタンが表示される' do
        expect(page).to have_button 'LOG IN'
      end
      it 'SIGN UPリンクが表示される:上から３番目のリンクが新規登録である' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(sign_up_link).to match(/SIGN UP/i)
      end
    end

    context 'リンク内容を確認' do
      subject { current_path }
      it 'SIGN UPを押すと新規登録画面に遷移する' do
        click_link 'signup-btn'
        is_expected.to eq '/users/sign_up'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'LOG IN'
      end
      it 'ログイン後のリダイレクト先がみんなの投稿画面になっている' do
        expect(current_path).to eq '/homes/about'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'LOG IN'
      end
      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end


  describe 'ユーザーログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'LOG IN'
      click_link 'nav-link6'
    end

    context 'ログアウト機能のテスト' do
      subject { current_path }

      it '正しくログアウトできている：ログアウト後のリダイレクト先において新規登録画面へのリンクが存在する' do
        expect(page). to have_link '', href: '/users/sign_up'
      end
      it '正しくログアウトできている：ログアウト後のリダイレクト先においてログイン画面へのリンクが存在する' do
        expect(page). to have_link '', href: '/users/sign_in'
      end
      it 'LOG OUTを押すとトップ画面に遷移する' do
        is_expected.to eq '/'
      end
    end
  end

end


#signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
                        # gsubメソッドは文字列の置換を行なっている
                        # \n(改行)、\A,\z(文字列の先頭,末尾)、\s(半角スペース、タブ、改行のどれか1文字)、*(直前の文字の0回以上の繰り返し)
                        # 上記が''(空白)に置換される
