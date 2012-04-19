class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]

  def new
    @user = User.new
  end

  def create
    cart_id = session[:cart_id]
    respond_to do |format|
      if @user = login(params[:email_address],params[:password])
        session[:cart_id] = cart_id unless cart_id.nil?
        format.html { redirect_back_or_to(root_path,
                      :notice => 'Login successful.') }
      else
        format.html { flash.now[:alert] = "Login failed.";
                      render :action => "new" }
      end
    end
  end

  def destroy
    logout
    clear_cart
    redirect_to(login_path, :notice => 'Logged out!')
  end
end
