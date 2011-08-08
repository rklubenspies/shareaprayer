class WaitlistsController < ApplicationController
  # GET /waitlists/new
  def new
    @waitlist = Waitlist.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /waitlists
  def create
    @waitlist = Waitlist.new(params[:waitlist])

    respond_to do |format|
      if @waitlist.save
        format.html { redirect_to root_url, notice: 'Thank you for your interest in Share a Prayer. We will send you an invite as soon as we can.' }
      else
        format.html { render action: "new" }
      end
    end
  end
end
