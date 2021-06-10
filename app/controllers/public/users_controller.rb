class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :edit_mypage, :update_mypage, :unsubscribe, :withdrawal]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end


# 会員情報の編集
  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user.id)
  end


  # マイページの編集
  def edit_mypage
    @user = User.find(params[:id])
  end

  def update_mypage
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user.id)
  end



  # 退会機能
  def unsubscribe
    @user = User.find(params[:id])
  end

  def withdrawal
    user = User.find(params[:id])
    ## is_deletedカラムをtrueに更新してフラグを立てる(defaultはfalse)
    user.update(is_deleted: true)
    ## ログアウト
    reset_session
    flash[:notice] = "ご利用ありがとうございました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end


  # フォロー・フォロワー
  def follows
        user  = User.find(params[:id])
        @users = user.following
  end

  def followers
        user  = User.find(params[:id])
        @users = @user.followers
  end



  # お気に入り表示
  def my_favorites
    user = User.find(params[:id])
    favorites = user.favorites.pluck(:post_id)
    @favorites_list = Post.find(favorites)
  end



  private


  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user = current_user
      redirect_to user_path(@user.id)
    end

  end


  def user_params
    params.require(:user).permit(:name, :email, :telephone_number, :user_name, :image, :self_introduction)
  end


end
