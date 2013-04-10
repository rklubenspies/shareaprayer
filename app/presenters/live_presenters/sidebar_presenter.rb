# Contains presenter logic for sidebar on all SAP Live pages
# 
# @since 1.0.0
# @author Robert Klubenspies
module LivePresenters
  class SidebarPresenter
    # Creates a new SidebarPresenter object and sets the @user
    # instance variable
    # 
    # @since 1.0.0
    # @author Robert Klubenspies
    # @param [User] user the user to present the sidebar for
    # @raise [InvalidUser] if the user provided does not exist
    def initialize(user = nil)
      raise "InvalidUser" if !User.exists?(user.id)
      @user = user
    end

    # User's name
    # 
    # @since 1.0.0
    # @author Robert Klubenspies
    # @return [String] the user's name
    def user_name
      @user.name
    end

    # User's profile pic from Facebook
    # 
    # @since 1.0.0
    # @author Robert Klubenspies
    # @return [String] the url of the photo
    def user_image_url
      @user.profile_pic_url
    end

    # User's churches
    # 
    # @since 1.0.0
    # @author Robert Klubenspies
    # @return [Array] the user's churches
    def churches
      @user.churches
    end

    # Convenience method - does the user have any churches?
    # 
    # @since 1.0.0
    # @author Robert Klubenspies
    # @return [Boolean] whether the user has any churches
    def no_churches?
      @user.churches.empty?
    end

    # User's churches for request form
    # 
    # @since 1.0.0
    # @author Robert Klubenspies
    # @return [Array] the user's churches
    def request_form_churches
      # Leave this as [c.name, c.id], otherwise the new request drop down will break
      @user.churches.collect { |c| [ c.name, c.id ] }
    end
  end
end