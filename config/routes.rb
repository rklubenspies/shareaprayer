Shareaprayer::Application.routes.draw do
  resources :groups

  resources :prayers

  root :to => "home#index"

  # OmniAuth
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  
  # Resources
  resources :users, :path => "/profile", :except => [:index], :constraints => { :id => /[^\/]+/ } do
    resources :prayers, :except => [:index]
  end
end
