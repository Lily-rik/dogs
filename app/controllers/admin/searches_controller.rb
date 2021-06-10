class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!
  
  def search
    @users = User.looks(params[:search], params[:word])
  end
  
  
end
