class Public::SearchesController < ApplicationController
  before_action :authenticate_user!


  def search
    @range = params[:range]
    @search = params[:search]
    if @range == "User"
      @users = User.looks(@search)
    elsif @search == "#"
      @posts = Hashtag.looks(@search)
    else
      @posts = Post.looks(@search)
    end
  end


end
