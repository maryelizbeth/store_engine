class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      if @user == current_user
        format.html # show.html.erb
        format.json { render json: @user }
      else
        redirect_to root_path
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        auto_login(@user)
        format.html { redirect_to(:products,
                      notice: 'User was successfully created.') }
      else
        format.html { render action: "new" }
      end
    end
  end
end
