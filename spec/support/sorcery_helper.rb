module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(email, password = "test")
        page.driver.post(user_sessions_url, { email_address: email, password: password })
        visit "/" # HACK - redirects to a "redirect" page post-login which has a single link that points to "example.com"
      end
    end
  end
end