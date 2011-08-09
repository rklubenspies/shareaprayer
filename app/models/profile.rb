class Profile < ActiveRecord::Base
  has_one :user
  
  def after_find
    if self.image.nil?
      self.image = "..."
      # self.image = "http://rjkgameserver.dyndns.org/assets/generic_profile_image.png"
    end
    if self.bio.nil?
      self.bio = ""
    end
  end
end
