Shareaprayer::Application.routes.draw do
  root :to => "home#index"
  
  # Dashboard
  match "/dashboard" => "dashboard#index", :as => :dashboard

  # OmniAuth
  match '/auth/facebook/logout' => 'application#facebook_logout', :as => :facebook_logout
  match "/auth/:provider/callback" => "authentications#create"
  match '/auth/failure' => 'users/authentications#failure'
  devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions' }
  resources :authentications
  
  # Resources
  resources :users, :path => "/profile", :except => [:index, :new, :create] do
    resources :prayers, :except => [:index, :new, :edit, :update]
  end
  
  resources :groups do
    member do
      post 'join'
      post 'leave'
    end
  end
  
  # API Namespace
  # This namespace allows us to call the API controllers with the api/ prefix on the URL
  # namespace :api do
  #     resources :users, :path => "/profile", :except => [:index, :create, :new], :constraints => { :id => /[^\/]+/ }, :defaults => { :format => 'json' }
  #     resources :prayers, :defaults => { :format => 'json' }
  #     resources :groups, :except => [:create, :new], :defaults => { :format => 'json' }
  #     match '/' => "api#index"
  #   end
end
