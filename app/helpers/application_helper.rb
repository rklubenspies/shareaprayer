module ApplicationHelper
  def timeago(time, options = {})
    options[:id] ||= "timeago"
    content_tag(:time, time.to_s, options.merge(:datetime => time.getutc.iso8601)) if time
  end
  
  def already_prayed_for?(prayer_id)
    (session[:prayed_for] ||= []).include? prayer_id.to_s
  end
  
  def prayed_for_number(user_prayed_for, count)
    if user_prayed_for
      if count == 1
        "You prayed for this."
      else
        "You and #{pluralize count-1, "other person"} prayed for this."
      end
    else
      if count == 0
        "Be the first to pray for this."
      else
        "#{pluralize count, "other person"} prayed for this."
      end
    end
  end
end