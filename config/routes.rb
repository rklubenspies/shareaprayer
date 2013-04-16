Shareaprayer::Application.routes.draw do
  constraints(subdomain: "") do
    get '*path' => redirect { |params, request|
      Addressable::URI.escape(request.url.sub(request.host, "www.#{request.host}"))
    }
  end

  constraints(subdomain: /^(|www)$/) do
    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

    get   '/vip' => 'vip#search',               as: :vip_search
    post  '/vip' => 'vip#handle_search',        as: :vip_handle_search
    get   '/vip/:code' => 'vip#show',           as: :vip
    post  '/vip/:code/signup' => 'vip#signup',  as: :vip_signup
    
    root to: 'pages#show', id: 'home'

    get '/:id', to: 'pages#show', as: :static
  end

  constraints(subdomain: /^(|api)$/) do
    scope module: "api" do
      get '/braintree/webhook', to: 'braintree#verify', as: :verify_braintree_webhook
      post '/braintree/webhook', to: 'braintree#webhook', as: :braintree_webhook
      get '/vip/new', to: 'vip#new', as: :new_vip
      post '/vip/create', to: 'vip#create', as: :create_vip
    end
  end

  constraints(subdomain: /^(|live)$/) do
    scope module: "live" do
      get '/' => 'recent#index', as: "recent"

      if !Rails.env.production?
        resources :search, only: [:index] do
          collection do
            post 'query'
          end
        end
      end

      resources :requests, only: [:create] do
        member do
          get 'pray_for'
        end
      end
      
      resources :church, only: [], as: "church" do
        member do
          get 'join'
          get 'leave'
          get 'manage'
          post 'update_profile'
        end
      end

      get '/:id' => 'church#show', as: "church"
    end
  end

  constraints(ChurchSubdomain) do
    get '/' => redirect { |params, request|
      "http://live.#{request.domain}/#{request.subdomain}"
    }
  end
end
