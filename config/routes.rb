StoreEngine::Application.routes.draw do
get "store/index"
root :to => 'store#index'
resources :user_sessions
resources :users
resources :products
resources :product_categories

match 'login' => 'user_sessions#new', :as => :login
match 'logout' => 'user_sessions#destroy', :as => :logout
end
