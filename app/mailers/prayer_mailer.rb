class PrayerMailer < ActionMailer::Base
  # include ActionController::UrlWriter
  default_url_options[:host] = 'shareaprayer.org'
  default from: "noreply@shareaprayer.org"
  
  def permalink_email(prayer)
    @prayer = prayer
    @url  = prayer_url(@prayer.id)
    # @url  = "http://shareaprayer.org/#{@prayer.id}"
    mail(:to => @prayer.email.email, :subject => "Your Prayer Has Been Posted")
  end
end
