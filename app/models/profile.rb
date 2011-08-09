class Profile < ActiveRecord::Base
  has_one :user
  after_find :update_info
  
  def update_info
    if self.image.nil?
      self.image = "/assets/generic_profile_image.png"
    end
    if self.bio.nil?
      self.bio = ""
    end
  end
end
