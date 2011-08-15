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
  before_filter :check_admin, :except => :redeem
  
  def redeem
    code = params[:code]
    @invite = Invite.find_by_code(code)
    
    if !@invite.nil? && !@invite.code.nil?
      redirect_to new_user_registration_path(:code => @invite.code), :alert => "Thanks! You may now sign up!"
    else
      redirect_to root_url, :alert => "Sorry, that invite code is not redeemable"
    end
  end
  
  def dashboard
    @waitlists = Waitlist.order(:created_at).page(params[:page]).per(50)
    # raise @waitlists.to_yaml
  end
  
  def invite
    @waitlist = Waitlist.find(params[:id])
    
    # Characters that our Invite codes can contain
    chars = [('a'..'z').to_a, ('A'..'Z').to_a, ('0'..'9').to_a].flatten - %w[i I l L o O 0 1]
    
    # Empty Invite code
    code = ""
    
    # Make Invite code
    while code.length < 6 do
      code << chars[rand(chars.size-1)]
    end
    
    # Create Invite
    @invite = Invite.new(:code => code, :prefix => "U#{current_user.id}")
    
    # If Invite saves, email address on waitlist, and delete address from waitlist
    if @invite.save
      mail = InvitationMailer.invite(@waitlist, @invite)
      if mail.deliver
        @waitlist.destroy
        redirect_to(invites_dashboard_url, :notice => "Invite sent to #{@waitlist.email}")
      else
        redirect_to(invites_dashboard_url, :notice => "We encountered a problem sending the invite.")
      end
    else
      redirect_to(invites_dashboard_url, :notice => "We encountered a problem sending the invite.")
    end
  end
  
  def invite_email
    # Characters that our Invite codes can contain
    chars = [('a'..'z').to_a, ('A'..'Z').to_a, ('0'..'9').to_a].flatten - %w[i I l L o O 0 1]
    
    # Empty Invite code
    code = ""
    
    # Make Invite code
    while code.length < 6 do
      code << chars[rand(chars.size-1)]
    end
    
    # Create Invite
    @invite = Invite.new(:code => code, :prefix => "U#{current_user.id}")
    
    # Create array to store email in to make the mailer happy
    @waitlist = Waitlist.new(:email => params[:email])
    
    # If Invite saves, email address on waitlist, and delete address from waitlist
    if @invite.save
      mail = InvitationMailer.invite(@waitlist, @invite)
      if mail.deliver
        redirect_to(invites_dashboard_url, :notice => "Invite sent to #{@waitlist.email}")
      else
        redirect_to(invites_dashboard_url, :notice => "We encountered a problem sending the invite.")
      end
    else
      redirect_to(invites_dashboard_url, :notice => "We encountered a problem sending the invite.")
    end
  end
  
  private
  def check_admin
    if current_user.nil? || current_user.role != "admin"
      redirect_to root_url, :notice => "Sorry, but you must be a logged in admin to access that URL."
    end
  end
end
