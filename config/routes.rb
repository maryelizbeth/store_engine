StoreEngine::Application.routes.draw do
root :to => 'store#index'

resources :user_sessions
resources :users
resources :products
resources :product_categories

get   "cart/show"
post  "cart/update"
post  "cart/remove_product", :as => :cart_remove_product
get   "cart/checkout",    :as => :checkout

get   "store/index"
post  "store/add_to_cart", :as => :add_to_cart

match 'login' => 'user_sessions#new', :as => :login
match 'logout' => 'user_sessions#destroy', :as => :logout
end
