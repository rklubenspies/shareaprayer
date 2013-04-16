class RequestDecorator < Draper::Decorator
  delegate_all

  # Returns the name to display for the request author. Honors their
  # privacy if they want to remain anonymous.
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the author's display name for this request
  def author
    source.anonymous? ? "Anonymous" : source.user.first_name
  end

  # Overrides created_at to make it more friendly and return a tag
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] a time tag containing the created at time
  def created_at
    time = source.created_at
    h.content_tag(:time, "#{h.time_ago_in_words(time)} ago", {datetime: time.getutc.iso8601, class: "timeago"})
  end

  # Displays the number of prayers a request received
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the friendly representation of the prayer count
  def prayers
    h.pluralize(source.prayers.count, 'prayer', 'prayers')
  end

  # Author's profile pic from Facebook
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] an image tag containing photo
  def profile_pic
    h.image_tag(source.user.profile_pic_url)
  end

  # Returns a short version of request, which has been limited to
  # 162 characters
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the short version of a request
  def short
    source.text.truncate(162, omission: "... (continued)")
  end

  # Returns a long version of request, which is essentially unchanged
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the long version of a request
  def long
    source.text
  end

  # Returns appropriate pray for button
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [User] current_user Devise's current_user
  # @return [String] the appropriate link_to tag
  def pray_for_button(current_user)
    if !current_user.has_prayed_for?(source.id)
      h.link_to("Pray for this", h.pray_for_request_path(source.id), remote: true)
    else
      h.link_to("You already prayed for this", h.pray_for_request_path(source.id), remote: true, disabled: true)
    end
  end
end
