class RegistrationsController < Devise::RegistrationsController
  def create
    invite_code = params[:invite_code]
    @invite = Invite.find_redeemable(invite_code)
    
    if invite_code && @invite 
      if session[:omniauth] == nil #OmniAuth
        if verify_recaptcha
          super
          flash[:alert] = nil
          session[:omniauth] = nil unless @user.new_record? #OmniAuth
          if resource.save
            @invite.redeemed!
          end
        else
          build_resource
          clean_up_passwords(resource)
          flash[:alert] = "There was an error with the recaptcha code below. Please re-enter the code and click submit."
          params[:invite_code] = invite_code
          render_with_scope :new
        end
      else
        super
        if resource.save
          @invite.redeemed!
        end
        resource.build_profile
        profile.valid?
        if profile.bio == nil
          profile.bio = ""
        end
        session[:omniauth] = nil unless @user.new_record? #OmniAuth
      end
    else
      redirect_to root_url, :notice => "Sorry, that invite code is not redeemable"
    end
  end
  
  private  
  def build_resource(*args)  
    super
    @user.role = "user"
    if session[:omniauth]  
      @user.apply_omniauth(session[:omniauth])  
      @user.valid?  
    end
  end
end