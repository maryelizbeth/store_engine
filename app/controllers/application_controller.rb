class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :find_cart_from_session
  before_filter :require_login

  protected
    def not_authenticated
      redirect_to login_path, :alert => "Please login first."
    end

    def find_cart_from_session
      @cart = Cart.find_by_id(session[:cart_id]) if session[:cart_id]
      @cart ||= Cart.create
      session[:cart_id] = @cart.id
    end

    def clear_cart
      @cart.delete if @cart
    end

    def require_admin
      unless current_user && current_user.admin?
        flash[:alert] = "You do not have permission to access this area."
        redirect_to root_path
      end
    end
end
