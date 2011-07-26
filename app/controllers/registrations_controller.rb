class RegistrationsController < Devise::RegistrationsController
  skip_authorization_check
  
  private  
  def build_resource(*args)  
    super  
    if session[:omniauth]  
      @user.apply_omniauth(session[:omniauth])  
      @user.valid?  
    end  
  end
  
  def create  
    super  
    session[:omniauth] = nil unless @user.new_record?   
  end
end