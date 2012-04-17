module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(email, password = DEFAULT_USER_PASSWORD, redirect_path = "/")
        page.driver.post(user_sessions_url, { email_address: email, password: password })
        visit redirect_path
      end

      def login_user(email, password = DEFAULT_USER_PASSWORD, redirect_path = "/")
        visit login_path
        fill_in "Email", :with => email
        fill_in "Password", :with => password
        click_button "Login"
      end
    end
  end
end