# Copyright (C) 2011 Robert Klubenspies. All rights reserved.
# 
# This file is part of Share a Prayer.
# 
# Share a Prayer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Share a Prayer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Share a Prayer.  If not, see <http://www.gnu.org/licenses/>.

require 'fb_graph'

class User < ActiveRecord::Base
  has_many :authentications, :dependent => :delete_all
  has_one :profile, :dependent => :delete
  has_many :prayers, :dependent => :delete_all
  belongs_to :group
  
  before_create :force_user_role
  before_create :build_default_profile
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :profile_attributes
  attr_protected :role
  
  accepts_nested_attributes_for :profile
  
  validates_presence_of :role, :screenname
  
  delegate :image, :to => :profile, :prefix => true, :allow_nil => true

  def to_param
    screenname
  end
  
  def picture_url
    if profile_image.present?
      profile_image
    else
      "/assets/generic_profile_image.png"   
    end
  end
  
  def apply_omniauth(omniauth)
    case omniauth['provider']
    when 'facebook'
      self.apply_facebook(omniauth)
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
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
    if self.profile != nil
      self.email = (omniauth['extra']['user_hash']['email'] rescue '')
      self.build_profile(:name => omniauth['user_info']['name'], :bio => omniauth['extra']['user_hash']['bio'], :image => omniauth['user_info']['image'])
    end
  end
  
  private
  def force_user_role
    if role.nil?
      self.role = "user" unless email.blank?
    end
  end
  
  private
  def build_default_profile
    build_profile
    true
  end
end
