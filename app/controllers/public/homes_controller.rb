class Public::HomesController < ApplicationController
  before_action :authenticate_user!,except: [:top]


  def top
  end

  def about
    @posts = Post.all
  end

end
