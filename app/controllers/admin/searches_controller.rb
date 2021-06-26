class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @search = params[:search]
    @users = User.looks(@search)
  end
end
