class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    controller, action = Rails.application.routes.recognize_path(request.referrer).values
    if controller == "public/posts" && action == "new"
      redirect_to new_post_path
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id), success: "投稿に成功しました"
    else
      flash.now[:info] = "投稿に失敗しました"
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user)

  end

  def edit
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      render :edit
    else
      redirect_to about_path, info: "自分の投稿以外は編集できません"
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.user_id = current_user.id
    if @post.update(post_params)
      redirect_to post_path(@post.id), success: "投稿を更新しました"
    else
      flash.now[:info] = "投稿に失敗しました"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.user_id = current_user.id
    post.destroy
    redirect_to user_path(post.user_id), info: "投稿を削除しました"
  end

  def ranking
    @ranking = Post.includes(:user).create_ranking # N+1問題の解消
  end

  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts.includes(:user).page(params[:page]).reverse_order # N+1問題の解消
  end



  private

  def post_params
    params.require(:post).permit(:caption, post_images_images: [])
  end

end
