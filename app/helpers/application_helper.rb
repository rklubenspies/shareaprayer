module ApplicationHelper
  # Sets page title on a per page basis
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @see http://stackoverflow.com/a/5275708/483418
  # @example Set title from view in HAML
  #   -title "Sample Church"
  # @example Set title from view in ERB
  #   <% title "Sample Church" %>
  def title(page_title)
    content_for(:title) { page_title }
    page_title
  end

  # Determine if there's a auth protected page to redirect to
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [Boolean] whether or not the redirect is present
  def auth_redirect?
    !session[:previous_url].blank? ? true : false
  end
end
