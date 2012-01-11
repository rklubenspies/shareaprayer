module ApplicationHelper
  def timeago(time, options = {})
    options[:id] ||= "timeago"
    content_tag(:time, time.to_s, options.merge(:datetime => time.getutc.iso8601)) if time
  end
end
