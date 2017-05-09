Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/history', to: 'home#history'
  get '/log',     to: 'home#log'
  match '/log_create' => 'home#log_create', :via => :post, :as => 'log_create'
end
