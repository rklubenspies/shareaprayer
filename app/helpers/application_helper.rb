# Helpers found in the ApplicationHelper are present in all views on the site.
# 
# @since 0.1.0
# @author Robert Klubenspies
module ApplicationHelper
  # Creates HTML5 time tag for use by the jquery.timeago plugin
  # 
  # @param time the timestamp of the entry we're generating a time tag for
  # @param [Array] options HTML options for the tag
  # @return [String] an HTML5 time tag
  # @since 0.1.0
  # @see http://timeago.yarp.com/ Timeago jQuery plugin website (timeago helper was derived from helper located under "Huh?" header)
  def timeago(time, options = {})
    # Assign HTML id as "timeago" if no other id is given
    options[:id] ||= "timeago"
    
    # Return HTML5 time tag
    content_tag(:time, time.to_s, options.merge(:datetime => time.getutc.iso8601)) if time
  end
  
  # Checks to see if a certain prayer request was already prayed for during the current session
  # 
  # @param [Integer] prayer_id the id of the Prayer object we'll be checking
  # @return [Boolean] whether or not the prayer_id was found in this session (true would indicate that it was found and that this Prayer was already prayed for)
  # @since 0.1.2
  # @see http://stackoverflow.com/questions/8959343/cannot-access-session-array-from-view-in-rails-3-1 Stack Overflow question which resolved that .to_s needed to be used in the helper 
  def already_prayed_for?(prayer_id)
    # Check for the prayed_for array stored in a session and if there is none, create an empty array.
    # Then check if the prayer_id's String representation is in the array.
    # Return the boolean result of this
    (session[:prayed_for] ||= []).include? prayer_id.to_s
  end
  
  # Generates a statement related to how many people prayed for a prayer
  # 
  # @param [Boolean] user_prayed_for wether or not the user looking at the prayer request already prayed for it
  # @param [Integer] count a count of how many time the prayer request has been prayed for
  # @return [String] a statement related to how many people prayed for a prayer
  # @since 0.1.2
  # @author Robert Klubenspies
  # @see ApplicationHelper#already_prayed_for? already_prayed_for? can be used to determine the value of the user_prayed_for parameter
  def prayed_for_number(user_prayed_for, count)
    # Has the user already prayed for this prayer request?
    if user_prayed_for
      # Was the user the only person who prayed for it?
      if count == 1
        "You prayed for this."
      # More than one person prayed for it
      else
        "You and #{pluralize count-1, "other person"} prayed for this."
      end
    # The user has nor prayed for this prayer request
    else
      # Does this prayer request have any prayers?
      if count == 0
        "Be the first to pray for this."
      # One or more people prayed for it
      else
        "#{pluralize count, "other person"} prayed for this."
      end
    end
  end
end