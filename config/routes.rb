require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # API namespace
  namespace :api, defaults: { format: :json } do
    post 'users/register', to: 'users#register'
    put '/shops/:id', to: 'shops#update', as: 'update_shop'
    post '/users/verify-email', to: 'users#verify_email'
    put '/users/:id/profile', to: 'users#update' # Added from new code
  end

  # ... other routes ...
end
