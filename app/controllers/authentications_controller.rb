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

class AuthenticationsController < ApplicationController  
  def index
    @authentications = current_user.authentications if current_user  
  end  

  def create
    omniauth = request.env["omniauth.auth"]
    session[:fb_token] = omniauth["credentials"]["token"] if omniauth['provider'] == 'facebook'
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])  
    if authentication  
      flash[:notice] = "Signed in successfully."  
      sign_in_and_redirect(:user, authentication.user)  
    elsif current_user  
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])  
      flash[:notice] = "Authentication successful."  
      redirect_to authentications_url  
    else  
      user = User.new  
      user.apply_omniauth(omniauth)  
      if user.save  
        flash[:notice] = "Signed in successfully."  
        sign_in_and_redirect(:user, user)  
      else  
        session[:omniauth] = omniauth
        redirect_to new_user_registration_url  
      end
    end
  end  

  def destroy
    @authentication = current_user.authentications.find(params[:id])  
    @authentication.destroy  
    flash[:notice] = "Successfully destroyed authentication."  
    redirect_to authentications_url
  end
  
  def failure
    render :text => "Login Failure!"
  end
  
  protected

  # This is necessary since Rails 3.0.4
  # See https://github.com/intridea/omniauth/issues/185
  # and http://www.arailsdemo.com/posts/44
  def handle_unverified_request
    true
  end
end
