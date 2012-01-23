# Methods found in the ApplicationController are available to all controllers that inherit from it.
# 
# @since 0.1.0
# @author Robert Klubenspies
class ApplicationController < ActionController::Base
  protect_from_forgery
end
