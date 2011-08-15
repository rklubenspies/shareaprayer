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

class RegistrationsController < Devise::RegistrationsController
  def create
    invite_code = params[:code]
    @invite = Invite.find_by_code(invite_code)
    
    if (invite_code && @invite) or current_user != nil
      if session[:omniauth] == nil #OmniAuth
        if verify_recaptcha
          super
          flash[:alert] = nil
          session[:omniauth] = nil unless @user.new_record? #OmniAuth
          if resource.save
            @invite.destroy
          end
        else
          build_resource
          clean_up_passwords(resource)
          flash[:alert] = "There was an error with the recaptcha code below. Please re-enter the code and click submit."
          params[:code] = invite_code
          render_with_scope :new
        end
      else
        super
        if resource.save
          @invite.destroy
        end
        resource.build_profile
        profile.valid?
        if profile.bio == nil
          profile.bio = ""
        end
        session[:omniauth] = nil unless @user.new_record? #OmniAuth
      end
    else
      redirect_to root_url, :notice => "Sorry, that invite code is not redeemable"
    end
  end
  
  private  
  def build_resource(*args)  
    super
    @user.role = "user"
    if session[:omniauth]  
      @user.apply_omniauth(session[:omniauth])  
      @user.valid?  
    end
  end
end