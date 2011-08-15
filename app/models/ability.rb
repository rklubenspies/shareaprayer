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

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role == "user"
      # User can read everything on the site
      can :read, :all
      
      # User can only update their account. User cannot create or destroy account.
      can :manage, User, :id => user.id
      
      # User can only create and destroy their own prayer requests
      can [:create, :destroy], Prayer, :user_id => user.id
      
      # User cannot edit, update, or destroy Groups
      can [:join, :leave], Group
      cannot [:create, :update, :destroy], Group
    else
      can :read, :all
    end
  end
end
