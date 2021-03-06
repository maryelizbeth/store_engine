class Admin::UsersController < ApplicationController
  before_filter :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
