class User < ActiveRecord::Base  
  def self.create_with_omniauth(auth)  
    create! do |user|  
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.name = auth["user_info"]["name"]
      user.email = auth["user_info"]["email"]
      user.screenname = auth["user_info"]["nickname"]
      user.bio = auth["extra"]["user_hash"]["bio"]
      user.religion = auth["extra"]["user_hash"]["religion"]
      user.political = auth["extra"]["user_hash"]["politicial"]
      user.image = auth["user_info"]["image"]
      user.provider_profile = auth["extra"]["user_hash"]["link"]
      user.role = "user"
    end
  end
  
  def facebook
    @fb_user ||= FbGraph::User.me(self.token)
  end
end
