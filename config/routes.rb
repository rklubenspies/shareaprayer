Shareaprayer::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  constraints(subdomain: /^(|www)$/) do
    root to: 'pages#show', id: 'home'

    get '/:id', to: 'pages#show', as: :static
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
