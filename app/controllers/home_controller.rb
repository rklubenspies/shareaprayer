class HomeController < ApplicationController
  def index
    @prayers = Prayer.order("created_at DESC").page(params[:page]).per(5)
  end
end
