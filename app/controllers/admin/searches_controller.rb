class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!
end
