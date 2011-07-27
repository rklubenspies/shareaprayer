class User < ActiveRecord::Base
  has_many :authentications
  has_one :profile
  has_many :prayers
  belongs_to :group
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def apply_omniauth(omniauth)
    case omniauth['provider']
    when 'facebook'
      self.apply_facebook(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil))
  end
  
  def password_required?  
    (authentications.empty? || !password.blank?) && super  
  end
  
  def update_with_password(params={})
    unless self.authentications.empty?
      params.delete(:current_password)
      self.update_without_password(params)
    end
    super
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end


  protected
  def apply_facebook(omniauth)
    self.email = (omniauth['extra']['user_hash']['email'] rescue '')
    self.build_profile(:name => omniauth['user_info']['name'], :bio => omniauth['extra']['user_hash']['bio'], :image => omniauth['user_info']['image'])
  end
end
