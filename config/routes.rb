StoreEngine::Application.routes.draw do
  
  get "store/index"

  resources :product_categories

root :to => 'users#index'
resources :user_sessions
resources :users
resources :products

match 'login' => 'user_sessions#new', :as => :login
match 'logout' => 'user_sessions#destroy', :as => :logout
end
