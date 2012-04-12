class PagesController < ApplicationController
  skip_before_filter :require_login
  
  def contact_us
  end
end