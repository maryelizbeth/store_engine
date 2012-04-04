StoreEngine::Application.routes.draw do
  
root :to => 'users#index'
resources :user_sessions
resources :users
resources :products

match 'login' => 'user_sessions#new', :as => :login
match 'logout' => 'user_sessions#destroy', :as => :logout
end
