class ApplicationController < ActionController::Base
  protect_from_forgery

  # Returns the User object for the currently logged in user
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [User] the currently logged in User
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  private :current_user
  helper_method :current_user

  # Check to see if a User is logged in
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [Boolean] whether or not a User is logged in
  def user_signed_in?
    !!current_user
  end
  private :user_signed_in?
  helper_method :user_signed_in?

  # Forces a user to be logged in. If they're not logged in, it
  # redirects them to Facebook auth.
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def require_authentication!
    if !user_signed_in?
      redirect_to "/auth/facebook"
    end
  end
  private :require_authentication!
  helper_method :require_authentication!
end
