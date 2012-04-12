StoreEngine::Application.routes.draw do
root :to => 'products#index'

resources :user_sessions
resources :users
resources :products, :only => [:index, :show]

get "orders/lookup"
resources :orders, :only => [:index, :show]

namespace :admin do
  resources :orders, :only => [:index, :show, :update]
  resources :products
  resources :product_categories
  resources :users, :only => [:index, :show]
end


get   "cart/show"
post  "cart/update"
post  "cart/remove_product", :as => :cart_remove_product
get   "cart/checkout",       :as => :checkout
post  "cart/convert_cart_to_order", :as => :convert_cart_to_order

post  "cart/add_to_cart", :as => :add_to_cart
get   "contact_us", :to => "pages#contact_us"

match 'login' => 'user_sessions#new', :as => :login
match 'logout' => 'user_sessions#destroy', :as => :logout
end
