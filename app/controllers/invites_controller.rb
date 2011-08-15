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

class InvitesController < ApplicationController
  def redeem
    code = params[:code]
    @invite = Invite.find_by_code(code)
    
    if !@invite.nil? && !@invite.code.nil?
      redirect_to new_user_registration_path(:code => @invite.code), :alert => "Thanks! You may now sign up!"
    else
      redirect_to root_url, :alert => "Sorry, that invite code is not redeemable"
    end
  end
end
