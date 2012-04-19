source 'https://rubygems.org'

gem 'rails', '3.2.3'
gem 'pg'
gem 'jquery-rails'
gem 'sorcery'
gem 'aasm'
gem 'best_in_place'
gem 'kaminari'
gem 'heroku'
gem 'faker'
gem 'fabrication'
gem 'twitter-bootstrap-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'guard'
  gem 'growl'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov'
  gem 'reek', :git => "git://github.com/mvz/reek.git", :branch => "ripper_ruby_parser-2"
  gem 'cane', :git => "git://github.com/square/cane.git"
end

group :production do
  gem 'thin'
end