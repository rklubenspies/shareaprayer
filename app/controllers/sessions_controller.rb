# Communicates with OmniAuth and processes user's login
# 
# @since 1.0.0
# @author Robert Klubenspies
class SessionsController < ApplicationController
  # Login URL, redirects users to OmniAuth
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def new
    redirect_to "/auth/facebook"
  end

  # Processes OmniAuth login callback (/auth/:provider/callback).
  # Logs in and redirects users where applicable.
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to (request.env['omniauth.origin'] || recent_index_path), notice: "Signed in!"
  end

  # Logs out user
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Signed out!'
  end
end
