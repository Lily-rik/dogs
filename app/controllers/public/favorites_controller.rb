class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post.create_notification_favorite!(current_user)
    favorite = current_user.favorites.new(post_id: @post.id) # 通知
    favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
