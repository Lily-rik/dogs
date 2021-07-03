class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :guest_sign_in]

  def top
  end

  def about
    @posts = Post.page(params[:page]).reverse_order
  end

  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@dogs.com') do |user|
      user.name = "ゲスト"
      user.user_name = "ゲスト"
      user.telephone_number = "00000000000"
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to about_path, notice: 'ゲストユーザーとしてログインしました。'
  end

end