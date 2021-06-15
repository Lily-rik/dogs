class Public::PostsController < ApplicationController
  before_action :authenticate_user!


  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    return render :new unless image_present?
    @post.user_id = current_user.id
    @post.save
    redirect_to post_path(@post.id)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end


  def edit
    @post = Post.find(params[:id])
  end


  def update
    post = Post.find(params[:id])
    post.user_id = current_user.id
    post.update(post_params)
    redirect_to post_path(post.id)
  end


  def destroy
    post = Post.find(params[:id])
    post.user_id = current_user.id
    post.destroy
    redirect_to user_path(post.user_id)
  end

  def ranking
    @ranking = Post.create_ranking
  end

  def hashtag
    @user = current_user
    @tag = Hashtag.find_by(hashname: params[:name])
    @posts = @tag.posts
  end


  private

  def post_params
    params.require(:post).permit(:image, :caption)
  end

  def image_present?
    post_params[:image].is_a?(ActionDispatch::Http::UploadedFile)
  end

end
