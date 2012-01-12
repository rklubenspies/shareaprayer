Shareaprayer::Application.routes.draw do
  match '/privacy' => 'legal#privacy'
  match '/tos' => 'legal#tos'
  
  namespace :api do
    namespace :v1 do
      resources :prayers, :only => [:index, :create, :show]
    end
  end
  
  resources :prayers, :only => [:index, :create, :show], :path => '/' do
    get 'report', :on => :member
    get 'prayed_for', :on => :member
  end
end
