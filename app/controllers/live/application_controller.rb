# Master controller for the Live namespace
# 
# @since 1.0.0
# @author Robert Klubenspies
class Live::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    @sidebar = LivePresenters::SidebarPresenter.new(current_user)
  end

  layout 'live'
end