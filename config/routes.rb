Shareaprayer::Application.routes.draw do
  if !Rails.env.production?  
    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

    get   '/vip' => 'vip#search',               as: :vip_search
    get   '/vip/:code' => 'vip#show',           as: :vip
    post  '/vip' => 'vip#show',                 as: :vip
    post  '/vip/:code/signup' => 'vip#signup',  as: :vip_signup
  end
  
  constraints(subdomain: /^(|www)$/) do
    root to: 'pages#show', id: 'home'

    get '/:id', to: 'pages#show', as: :static
  end

  if !Rails.env.production?  
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
end
