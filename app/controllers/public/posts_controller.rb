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
    # return render :new unless image_present?
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      flash.now[:error] = "登録に失敗しました"
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      render :edit
    else
      redirect_to about_path
    end
  end

  def update
    @post = Post.find(params[:id])
    # return render :edit unless image_present?
    @post.user_id = current_user.id
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
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
    @posts = @tag.posts.page(params[:page]).reverse_order
  end

  private

  def post_params
    params.require(:post).permit(:caption, post_images_images: [])
  end

  # def image_present?
  #   post_params[:image].is_a?(ActionDispatch::Http::UploadedFile)
  # end
end
