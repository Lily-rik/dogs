class Public::SearchesController < ApplicationController
  before_action :authenticate_user!


  def search
    @users = User.looks(params[:search], params[:word])

  end



end
