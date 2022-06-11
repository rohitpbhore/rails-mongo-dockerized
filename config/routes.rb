Rails.application.routes.draw do
  root to: 'posts#index'
  resources :posts do
    resources :comments
  end

  resources :users
  post '/auth/login', to: 'auth#login'
  get '/*a', to: 'application#routing_error'
end