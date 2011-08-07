class InvitesController < ApplicationController
  load_resource :except => [:redeem, :create]
  authorize_resource :except => [:redeem]
  
  # GET /invites
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /invites/new
  def new
  end

  # POST /invites
  def create
    @invite = Invite.new
    @invite.email = params[:invite][:email]
    if @invite.save
      redirect_to root_url, notice: 'Thank you for requesting an invite! We will email you one as soon as it comes available!'
    else
      render action: "new"
    end
  end

  # DELETE /invites/1
  def destroy
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to invites_url }
    end
  end
  
  # POST /send_invitation/1
  def send_invitation
    @invite.invite!
    mail = InvitationMailer.invite(@invite)
    mail.deliver
    redirect_to(invites_url, :notice => "Invite sent to #{@invite.email}")
  end
  
  # GET /redeem/ymUdKC
  def redeem
    invite_code = params[:invite_code]
    @invite = Invite.find_redeemable(invite_code)
    
    if !invite_code or !@invite
      redirect_to root_url, :notice => "Sorry, that invite code is not redeemable"
    end
  end
end
