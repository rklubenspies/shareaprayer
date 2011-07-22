class HomeController < ApplicationController
  def index
    @prayers = Prayer.all(:limit => 2)
  end
end
