Shareaprayer::Application.routes.draw do
  # ADD ROOT ROUTE
  
  # OmniAuth
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
