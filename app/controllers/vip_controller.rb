# Handles VIP signup logic
# 
# @since 1.0.0
# @author Robert Klubenspies
class VipController < ApplicationController
  layout 'vip'

  def search
  end

  def show
    @vip = VipSignup.where(code: params[:code]).first

    if !@vip
      redirect_to vip_search_path, error: "Please enter a valid VIP code"
    end
  end

  def signup
    alterations = params[:vip]
    vip = VipSignup.where(code: params[:code]).first

    church = vip.create_church_with_alterations(alterations, current_user.id)

    if church
      redirect_to
    else
      redirect_to vip_search_path, error: "An unknown error has occurred trying to set up your church. Please contact support at support@shareaprayer.org."
    end
  end
end