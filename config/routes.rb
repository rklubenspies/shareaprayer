Shareaprayer::Application.routes.draw do
  constraints(subdomain: /^(|www|live)$/) do
    get '/login',
      to: 'sessions#new',
      as: :login

    get '/logout',
      to: 'sessions#destroy',
      as: :logout

    match '/auth/:provider/callback',
      to: 'sessions#create',
      as: :omniauth_callback
  end

  constraints(subdomain: /^(|www)$/) do
    root to: 'high_voltage/pages#show', id: 'home'

    get '/:id',
      to: 'high_voltage/pages#show',
      as: :static
  end
  
  constraints(subdomain: /^(|live)$/) do
    scope module: "live" do
      get '/' => 'recent#index', as: "recent"
      get '/:id' => 'church#show', as: "church"

      resources :requests, only: [:create]
      resources :church, only: [], as: "church" do
        member do
          get 'join'
          get 'leave'
        end
      end
    end
  end

  constraints(ChurchSubdomain) do
    get '/' => redirect { |params, request|
      "http://live.#{request.domain}/#{request.subdomain}"
    }
  end
end
