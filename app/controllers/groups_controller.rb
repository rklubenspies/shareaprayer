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

class GroupsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => [:join, :leave]
  
  # GET /groups
  def index
    @groups = @groups.order("created_at DESC").page(params[:page]).per(25)
    
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /groups/friendly-id
  def show
    @prayers = @group.prayer.order("created_at DESC").page(params[:page]).per(5)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /groups/new
  def new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /groups/friendly-id/edit
  def edit
  end

  # POST /groups
  def create
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /groups/friendly-id
  def update
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /groups/friendly-id
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
    end
  end
  
  # POST /groups/friendly-id/join
  def join
    @group = Group.find(params[:id])
    @user = current_user
    @user.group_id = @group.id
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @group, notice: 'You have successfully joined this group.' }
      else
        format.html { redirect_to @group, notice: 'We encountered an error when trying to add you to this group. Please try again later.' }
      end
    end
  end
  
  # POST /groups/friendly-id/leave
  def leave
    @group = Group.find(params[:id])
    @user = current_user
    @user.group_id = nil
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @group, notice: 'You have successfully left this group.' }
      else
        format.html { redirect_to @group, notice: 'We encountered an error when trying to remove you from this group. Please try again later.' }
      end
    end
  end
end
