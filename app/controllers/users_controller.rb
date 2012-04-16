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

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if request.post?
      if params[:user][:password].empty?
      # password not edited
      params[:user][:password] = @user.password
      params[:user][:password_confirmation] = @user.password
    end
      if @user.update_attributes(params[:user])
          flash[:notice] = "Your details have been updated"
          redirect_to :action => 'users_edit_path'
      end
    end
    @user.password = nil
    @user.password_confirmation = nil
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        auto_login(@user)
        format.html { redirect_to(:products, notice: 'User was successfully created.') }
        # format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
