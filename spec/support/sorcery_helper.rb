module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(email, password = "test", redirect_path = "/")
        page.driver.post(user_sessions_url, { email_address: email, password: password })
        # HACK - redirects to a "redirect" page post-login which has 
        # a single link that points to "example.com"
        visit redirect_path 
      end
    end
  end
end