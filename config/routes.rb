StoreEngine::Application.routes.draw do
root :to => 'store#index'

resources :user_sessions
resources :users
resources :products
resources :product_categories
resources :orders


get   "cart/show"
post  "cart/update"
post  "cart/remove_product", :as => :cart_remove_product
get   "cart/checkout",    :as => :checkout
post  "cart/add_to_cart", :as => :add_to_cart

get   "order/index"
get   "order/show"
post  "order/process_order",    :as => :process_order

get   "store/index"

match 'login' => 'user_sessions#new', :as => :login
match 'logout' => 'user_sessions#destroy', :as => :logout
end
