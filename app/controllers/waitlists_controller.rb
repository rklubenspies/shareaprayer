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

class WaitlistsController < ApplicationController
  # GET /waitlists/new
  def new
    @waitlist = Waitlist.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /waitlists
  def create
    @waitlist = Waitlist.new(params[:waitlist])

    respond_to do |format|
      if @waitlist.save
        format.html { redirect_to root_url, notice: 'Thank you for your interest in Share a Prayer. We will send you an invite as soon as we can.' }
      else
        format.html { render action: "new" }
      end
    end
  end
end
