# The PrayerMailer emails users permalinks to their prayer requests.
# 
# @since 0.1.0
# @author Robert Klubenspies
class PrayerMailer < ActionMailer::Base
  # Set default values
  default_url_options[:host] = 'shareaprayer.org'
  default from: "noreply@shareaprayer.org"
  
  # Emails user permalink to their prayer request
  # 
  # @param [Array] prayer the Prayer object that needs to to be permalinked
  # @since 0.1.0
  # @author Robert Klubenspies
  def permalink_email(prayer)
    # Assign prayer to instance varaible so that we can pass it into the mailer view
    @prayer = prayer
    
    # Create url for prayer request
    @url  = prayer_url(@prayer.id)
    
    # Email user with content from mailer view located at app/views/prayer_mailer/permalink_email.text.erb
    mail(:to => @prayer.email.email, :subject => "Your Prayer Has Been Posted")
  end
end
