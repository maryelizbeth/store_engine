class PagesController < ApplicationController
  skip_before_filter :require_login
  
  def contact_us
  end

  def process_email
  end
  
  def to_github
    redirect_to "https://github.com/maryelizbeth/store_engine/"
  end
end