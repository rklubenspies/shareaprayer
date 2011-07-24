Shareaprayer::Application.routes.draw do
  root :to => "home#index"

  # OmniAuth
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  
  # Resources
  resources :users, :path => "/profile", :except => [:index], :constraints => { :id => /[^\/]+/ } do
    resources :prayers, :except => [:index]
  end
  
  resources :groups do
    # collection do
    #   get 'join'
    #   get 'leave'
    # end
  end
end
