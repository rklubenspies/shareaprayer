# Handles VIP signup logic
# 
# @since 1.0.0
# @author Robert Klubenspies
class VipController < ApplicationController
  layout 'vip'

  def search
  end

  def show
    @vip = VipSignup.where(code: params[:code], state: "pending").first

    if !@vip
      redirect_to vip_search_path, :flash => { :error => "Please enter a valid VIP code" }
    end
  end

  def signup
    alterations = params[:vip]
    vip = VipSignup.where(code: params[:code]).first

    church = vip.create_church_with_alterations(alterations, current_user.id)

    if church
      redirect_to church_url(church.subdomain, subdomain: "live"), notice: "You're ready to roll! Welcome aboard!"
    else
      redirect_to vip_search_path, :flash => { :error => "An unknown error has occurred. Please contact support." }
    end
  end
end