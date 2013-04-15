class ShowChurchDecorator < ChurchDecorator
  delegate_all

  # Church's address formatted for pretty output
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's address
  def formatted_address
    if raw_address
      output = "#{raw_address.street}\n#{raw_address.city}, #{raw_address.state} #{raw_address.zip}"
      return h.sanitize(output.gsub("\n", "<br>").html_safe, :tags => ["br"])
    end
  end

  # Link to Church's website
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's website
  def website_link
    if source.profile.website
      return h.link_to(raw_website, raw_website)
    end
  end

  # Join group call to action
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [User] current_user Devise's current_user
  def join_group_call_to_action(current_user)
    if current_user.is_not_church_member?(source.id)
      h.render partial: "live/church/join_group_call_to_action", locals: { name: name, subdomain: source.subdomain }
    end
  end

  # Post request form for church members
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Array] options the array of Church options
  #   for the drop down
  # @param [User] current_user Devise's current_user
  def members_request_form(options, current_user)
    if current_user.is_church_member?(source.id)
      h.render partial: "live/shared/post_request", locals: { churches: options, current_page: "church-#{source.id}" }
    end
  end

  # Leave Prayer Group button
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [User] current_user Devise's current_user
  def leave_prayer_group_button(current_user)
    if current_user.is_church_member?(source.id)
      h.link_to "Leave Prayer Group", h.leave_church_path(source.subdomain), class: "leave"
    end
  end

  # Manage Church button
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [User] current_user Devise's current_user
  def manage_church_button(current_user)
    if current_user.is_church_manager?(source.id)
      h.link_to "Manage Church", h.manage_church_path(source.subdomain), class: "manage"
    end
  end
end
