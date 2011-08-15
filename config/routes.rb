# Copyright (C) 2011 Robert Klubenspies. All rights reserved.
# 
# This file is part of Share a Prayer.
# 
# Share a Prayer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Share a Prayer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Share a Prayer.  If not, see <http://www.gnu.org/licenses/>.

Shareaprayer::Application.routes.draw do
  # Dashboard
  match '/dashboard' => 'dashboard#index', :as => :dashboard

  # OmniAuth
  match '/auth/facebook/logout' => 'application#facebook_logout', :as => :facebook_logout
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/failure' => 'users/authentications#failure'
  
  # Authentication
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
  
  # Invites
  resources :waitlists, :path => '/invites/waitlist'
  match '/invites/redeem/:code' => 'invites#redeem', :as => :redeem_invite
  match '/invites/dashboard' => 'invites#dashboard', :as => :invites_dashboard
  match '/invites/dashboard/invite/:id' => 'invites#invite', :as => :invites_dashboard_invite
  match '/invites/dashboard/invite_email' => 'invites#invite_email', :as => :invites_dashboard_invite_email, :via => :post
  
  # Settings
  match '/settings' => 'settings#index', :as => :settings, :via => :get
  match '/settings' => 'settings#update', :as => :update_settings, :via => :put
  
  # Legal Stuff
  match '/terms' => 'legal#terms', :as => :terms, :via => :get
  match '/privacy' => 'legal#privacy', :as => :privacy_policy, :via => :get
  
  # API Namespace
  # This namespace allows us to call the API controllers with the api/ prefix on the URL
  # namespace :api do
  #     resources :users, :path => "/profile", :except => [:index, :create, :new], :constraints => { :id => /[^\/]+/ }, :defaults => { :format => 'json' }
  #     resources :prayers, :defaults => { :format => 'json' }
  #     resources :groups, :except => [:create, :new], :defaults => { :format => 'json' }
  #     match '/' => "api#index"
  #   end
  
  # Root Route
  root :to => 'home#index'
end
