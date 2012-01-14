module ApplicationHelper
  def timeago(time, options = {})
    options[:id] ||= "timeago"
    content_tag(:time, time.to_s, options.merge(:datetime => time.getutc.iso8601)) if time
  end
  
  # CREDIT: http://railscasts.com/episodes/244-gravatar
  def gravatar_url(email)
    if email.gravatar_url.present?  
      email.gravatar_url  
    else
      # We used the prayers_url in the default route below because it acts as our root_url; there is no root_url, just a prayers_url in its place
      default_url = "#{prayers_url}images/guest.png"  
      gravatar_id = Digest::MD5::hexdigest(email.email).downcase  
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=#{CGI.escape(default_url)}"  
    end  
  end
end
