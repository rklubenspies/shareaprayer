module ApplicationHelper
  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end
  
  def prayers_count
    @prayers_count = Rails.cache.fetch(:prayers_count, :expires_in => 8.hours) { Prayer.count }
  end
end
