class Public::HomesController < ApplicationController
  before_action :authenticate_user!,except: [:top]


  def top
  end

  def about
    @posts = Post.page(params[:page]).reverse_order
  end

end
