class ApplicationController < ActionController::Base
  protect_from_forgery
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
end
