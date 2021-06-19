class Public::SearchesController < ApplicationController
  before_action :authenticate_user!


  def search
    @range = params[:range]
    @search = params[:search]
    if @range == "User"
      @users = User.looks(@search).page(params[:page]).reverse_order.per(1)
    elsif @search == "#"
      @posts = Hashtag.looks(@search).page(params[:page]).reverse_order.per(1)
    else
      @posts = Post.looks(@search).page(params[:page]).reverse_order.per(1)
    end
  end


end
