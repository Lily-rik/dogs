class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :edit_mypage, :update_mypage, :unsubscribe, :withdrawal]

  def index
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id).page(params[:page]).reverse_order
  end

  # 会員情報の編集
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), success: "会員情報を更新しました"
    else
      flash.now[:info] = "更新に失敗しました"
      render :edit
    end
  end

  # マイページの編集
  def edit_mypage
    @user = User.find(params[:id])
  end

  def update_mypage
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), success: "マイページ情報を更新しました"
    else
      flash.now[:info] = "更新に失敗しました"
      render :edit_mypage
    end
  end

  # 退会機能
  def unsubscribe
    @user = User.find(params[:id])
  end

  def withdrawal
    user = current_user
    if user.email == "guest@dogs.com"
      redirect_to user_path(current_user), info: "ゲストユーザーは退会することができません。"
    else
      user.update(is_deleted: true) ## is_deletedカラムをtrueに更新してフラグを立てる(defaultはfalse)
      reset_session ## ログアウト
      flash[:danger] = "退会しました。"
      redirect_to root_path
    end
  end

  # フォロー・フォロワー
  def follows
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).reverse_order.per(5)
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).reverse_order.per(5)
  end

  # お気に入り表示
  def my_favorites
    @user = User.find(params[:id])
    favorites = @user.favorites.pluck(:post_id)
    @favorites_list = Post.where(id: favorites).includes(:user).page(params[:page]).reverse_order
  end

  private

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user.id)
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :telephone_number, :user_name, :image, :self_introduction)
  end
end
