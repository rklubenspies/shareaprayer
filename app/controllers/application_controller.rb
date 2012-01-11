class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :check_cookies
  # 
  # def check_cookies
  #   if cookies[:prayed_for] == nil
  #     cookies[:prayed_for] = []
  #   end
  #   if cookies[:reported] == nil
  #     cookies[:reported] = []
  #   end
  # end
end
