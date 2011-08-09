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
