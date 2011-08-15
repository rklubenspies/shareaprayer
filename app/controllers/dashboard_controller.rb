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

class DashboardController < ApplicationController
  before_filter :redirect_to_home
  before_filter :check_profile
  respond_to :html, :js
  
  def index
    @user = current_user
    if @user.group == nil
      @prayers = @user.prayers.order("created_at DESC").page(params[:page]).per(5)
    else
      @prayers = @user.group.prayer.order("created_at DESC").page(params[:page]).per(5)
    end
  end
  
  private
  def redirect_to_home
    if !user_signed_in?
      redirect_to root_path
    end
    false
  end
  
  private
  def check_profile
    profile = current_user.profile
    if profile.name.nil?
      redirect_to settings_path, :alert => "Please ensure that all required profile fields are filled in before using Share a Prayer."
    end
  end
end
