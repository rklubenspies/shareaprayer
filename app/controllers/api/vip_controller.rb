# Gives sales people a place to create VIP codes
# 
# @since 1.0.0
# @author Robert Klubenspies
class Api::VipController < Api::ApplicationController
  def new
    @plans = Plan.all.collect { |p| [ "#{p.name}: #{p.human_cost}", p.id ] }
  end

  def create
    data = params[:vip]

    info = {
      name:       data[:name],
      subdomain:  data[:subdomain],
      bio:        data[:bio],
      address:    data[:address],
      phone:      data[:phone],
      website:    data[:website],
    }

    vip = VipSignup.generate(params[:vip][:plan], info, params[:vip][:rep_uid])

    if vip
      redirect_to new_vip_path, notice: "Code created! VIP code is #{vip.code}. Sign up link: #{vip_url(vip.code, subdomain: 'www')}"
    else
      redirect_to new_vip_path, params: info, alert: "There was a problem creating the code. Please ensure everything is filled out correctly and try again."
    end
  end
end