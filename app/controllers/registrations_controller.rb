class RegistrationsController < Devise::RegistrationsController
  def create
    if session[:omniauth] == nil #OmniAuth
      if verify_recaptcha
        super
        session[:omniauth] = nil unless @user.new_record? #OmniAuth
      else
        build_resource
        clean_up_passwords(resource)
        flash[:alert] = "There was an error with the recaptcha code below. Please re-enter the code and click submit."
        render_with_scope :new
      end
    else
      super
      resource.build_profile
      profile.valid?
      if profile.bio == nil
        profile.bio = ""
      end
      session[:omniauth] = nil unless @user.new_record? #OmniAuth
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