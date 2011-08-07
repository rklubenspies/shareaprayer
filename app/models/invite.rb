class Invite < ActiveRecord::Base
  validates_presence_of :email, :on => :save, :message => "can't be blank"
  validates_uniqueness_of :email, :on => :save, :message => "is already registered or requested an invite"

  scope :unsent_invitations, :conditions => {:redeemed_at => nil, :invite_code => nil}

  def invited?
    !!self.invite_code && !!self.invited_at
  end

  def invite!
    self.invite_code = strand(6)
    self.invited_at = Time.now.utc
    self.save!
  end

  def self.find_redeemable(invite_code)
    self.find(:first, :conditions => {:redeemed_at => nil, :invite_code => invite_code})
  end

  def redeemed!
    self.redeemed_at = Time.now.utc
    self.save!
  end
  
  
  # START INVITE BACKBONE (Adapted from http://solutious.com/blog/2009/05/24/invite-codes-on-business-cards/)
  # An Array with ambiguous characters removed: i, I, l, L, o, O, 0, 1
  CHARS = [('a'..'z').to_a, ('A'..'Z').to_a, ('0'..'9').to_a].flatten - %w[i I l L o O 0 1]

  def strand(len, str='')
     str << CHARS[rand(CHARS.size-1)]
     str.size == len ? str : strand(len, str)
  end
  # END INVITE BACKBONE
end
