Shareaprayer::Application.routes.draw do
  get '/login',
    to: 'sessions#new',
    as: :login

  get '/logout',
    to: 'sessions#destroy',
    as: :logout

  match '/auth/:provider/callback',
    to: 'sessions#create',
    as: :omniauth_callback

  namespace :live do
    resources :requests, only: [:create]
    
    resources :church, only: [:show], as: "church" do
      member do
        get 'join'
        get 'leave'
      end
    end
  end

  root to: 'high_voltage/pages#show', id: 'home'
  
  get '/:id',
    to: 'high_voltage/pages#show',
    as: :static
end
