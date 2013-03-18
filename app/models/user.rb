# Stores users
# 
# @since 1.0.0
# @author Robert Klubenspies
# @note User uses rolify to faciliate roles on User model, as well as on any
#   resource object.
class User < ActiveRecord::Base
  # @!attribute first_name
  #   @return [String] user's first name

  # @!attribute last_name
  #   @return [String] user's last name

  # @!attribute email
  #   @return [String] user's email address
  #   @see This is usually provided by Facebook on sign up

  # @!attribute facebook_id
  #   @return [Integer] user's Facebook UID

  # @!attribute facebook_token
  #   @return [String] user's Facebook access token, usually used to verify login
  #     or execute offline Graph API queries

  # @!attribute facebook_token_expires_at
  #   @return [DateTime] when the user's current Facebook token expires

  rolify
  attr_accessible :first_name, :last_name, :email, :facebook_id, :facebook_token, :facebook_token_expires_at
  has_many :church_memberships, dependent: :destroy
  has_many :churches, through: :church_memberships
  has_many :church_managerships, dependent: :destroy
  has_many :managed_churches, through: :church_managerships
  has_many :requests, dependent: :destroy
  has_many :prayers, dependent: :destroy
  has_many :reported_content, as: :owner, dependent: :destroy

  # A convenience method that returns a user's fullname
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the user's full name
  def name
    "#{first_name} #{last_name}"
  end

  # Processes an OmniAuth hash to either log in or create a user
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] omniauth the OmniAuth auth hash
  # @return [User] the user found by the auth hash
  def self.from_omniauth(omniauth)
    # @comment allow access to hash keys by string or symbol
    omniauth = omniauth.with_indifferent_access

    user = self.where({ facebook_id: omniauth[:uid] }).first
    user ? user.update_from_omniauth(omniauth) : self.create_from_omniauth(omniauth)
  end

  # Updates a User from an omniauth hash. Used by .from_omniauth during
  # existing user login.
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] omniauth the OmniAuth auth hash
  # @return [User] the user updated by the auth hash
  def update_from_omniauth(omniauth)
    user = self

    possible_new_info = {
      # first_name:                 omniauth[:info][:first_name],
      # last_name:                  omniauth[:info][:last_name],
      # email:                      omniauth[:info][:email],
      facebook_token:             omniauth[:credentials][:token],
      facebook_token_expires_at:  Time.at(omniauth[:credentials][:expires_at])
    }

    update_opts = {}

    # @comment add a key to update_opts for each key that was changed
    possible_new_info.each do |key, opt|
      update_opts[key] = possible_new_info[key] if user[key] != possible_new_info[key] && !possible_new_info[key].blank?
    end

    user.update_attributes(update_opts)
    
    return user
  end

  # Creates a User from an omniauth hash. Used by .from(omniauth).
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] omniauth the OmniAuth auth hash
  # @return [User] the user created by the auth hash
  def self.create_from_omniauth(omniauth)
    create! do |user|
      user.first_name                 = omniauth[:info][:first_name]
      user.last_name                  = omniauth[:info][:last_name]
      user.email                      = omniauth[:info][:email]
      user.facebook_id                = omniauth[:uid].to_i
      user.facebook_token             = omniauth[:credentials][:token]
      user.facebook_token_expires_at  = Time.at(omniauth[:credentials][:expires_at])
    end
  end

  # Adds a user as a member of a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church which the user is joining
  # @return [ChurchMembership] the newly created ChurchMembership object
  # @raise [UserNotSignedUp] if the user is not a signed up user
  # @raise [UserAlreadyChurchMember] if the user already belongs to the church
  def join_church(church_id)
    user = self
    church = Church.find(church_id)

    raise "UserNotSignedUp" if !user.has_role?("site_user")
    raise "UserAlreadyChurchMember" if ChurchMembership.where(user_id: user.id, church_id: church_id).exists?

    user.churches << church
  end

  # Removes a user as a member of a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church which the user is leaving
  # @return [Boolean] success of transaction
  # @raise [UserNotChurchMember] if the user does not belong to the church
  def leave_church!(church_id)
    user = self
    membership = ChurchMembership.where(user_id: user.id, church_id: church_id)

    raise "UserNotChurchMember" if !membership.exists?

    # @comment return true or false instead of deleted object
    membership.destroy_all ? true : false
  end

  # Is the user a member of a church?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church where the user should be
  #   a member
  # @return [Boolean] true if the user is a member, false if not
  def is_church_member?(church_id)
    user = self
    ChurchMembership.where(user_id: user.id, church_id: church_id).exists?
  end

  # Is the user NOT a member of a church?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church where the user should not
  #   be a member
  # @return [Boolean] true if the user is not a member, false if they are
  def is_not_church_member?(church_id)
    user = self
    !ChurchMembership.where(user_id: user.id, church_id: church_id).exists?
  end

  # Is the user a manager of a church?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church where the user should be
  #   a manager
  # @return [Boolean] true if the user is a manager, false if not
  def is_church_manager?(church_id)
    user = self
    ChurchManagership.where(user_id: user.id, church_id: church_id).exists?
  end

  # Is the user NOT a manager of a church?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church where the user should not
  #   be a manager
  # @return [Boolean] true if the user is not a manager, false if they are
  def is_not_church_manager?(church_id)
    user = self
    !ChurchManagership.where(user_id: user.id, church_id: church_id).exists?
  end

  # Posts a request
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] opts a the options to create a request with
  # @option opts [String] :text the request's full text
  # @option opts [Boolean] :anonymous whether or not the request is posted
  #   anonymously. Will default to false if key is not present.
  # @option opts [String] :ip_address the orriginating ip address of the request
  # @param [Integer] church_id the id of the church the request was posted into
  # @return [Request] the newly created Request object
  # @raise [UserNotChurchMember] if the user does not belong to the church they
  #   are trying to post a request into
  # @raise ChurchRequiredToPost if the user tries to post the request without
  #   providing a church_id
  def post_request(opts, church_id)
    user = self

    raise "UserNotChurchMember" if user.is_not_church_member?(church_id) && !church_id.blank?
    raise "ChurchRequiredToPost" if church_id.blank?

    build_opts = {
      text: opts[:text],
      anonymous: opts.has_key?(:anonymous) ? opts[:anonymous] : false
    }

    request = user.requests.build(build_opts)
    request.ip_address = opts["ip_address"]
    request.church_id = church_id

    request.save!
    request
  end

  # Prays for a request
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] request_id the request to pray for
  # @param [String] ip_address the orriginating ip address of the prayer
  # @return [Prayer] the newly created Prayer object
  # @raise [UserAlreadyPrayedForRequest] if the user already prayed for the
  #   request before
  def pray_for(request_id, ip_address = nil)
    user = self

    raise "UserAlreadyPrayedForRequest" if user.has_prayed_for?(request_id)

    Prayer.create!(user_id: user.id, request_id: request_id, ip_address: ip_address)
  end

  # Has the user prayed for a request?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] request_id the id of the request the user should have
  #   prayed for
  # @return [Boolean] true if the user prayed for this request, false if not
  def has_prayed_for?(request_id)
    user = self
    Prayer.where(user_id: user.id, request_id: request_id).exists?
  end

  # Has the user NOT prayed for a request?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] request_id the id of the request the user should not
  #   have prayed for
  # @return [Boolean] true if the user has not prayed for this request,
  #   false if they have
  def has_not_prayed_for?(request_id)
    user = self
    !Prayer.where(user_id: user.id, request_id: request_id).exists?
  end

  # Reports an object (like a Request)
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Object] object the object to report
  # @param [Hash] opts the options to create a request with
  # @option opts [Integer] :priority the priority of the report
  #   (see ReportedContent for more info)
  # @option opts [String] :reason the reason a user is reporting the
  #   request
  # @option opts [String] :ip_address the orriginating ip address of the
  #   report
  # @return [ReportedContent] the newly created ReportedContent object
  # @raise [UserAlreadyReportedObject] if the user already reported the
  #   request before
  def report_object(object, opts = { priority: 0 })
    user = self

    raise "UserAlreadyReportedObject" if user.has_reported_object?(object)

    build_opts = {
      priority: opts[:priority],
      reason: opts[:reason],
      ip_address: opts[:ip_address]
    }
    reported_content = object.reports.build(build_opts)
    reported_content.owner = user
    
    reported_content.save!
    reported_content
  end

  # Has the user reported an object?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Objecy] object the object the user should have reported
  # @return [Boolean] true if the user reported this object, false if not
  def has_reported_object?(object)
    user = self

    criteria = {
      owner_id: user.id,
      reportable_id: object.id,
      reportable_type: object.class.to_s
    }

    ReportedContent.where(criteria).exists?
  end

  # Has the user NOT reported an object?
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Objecy] object the object the user should not have reported
  # @return [Boolean] true if the user has not reported this object,
  #   false if they have
  def has_not_reported_object?(object)
    user = self
    
    criteria = {
      owner_id: user.id,
      reportable_id: object.id,
      reportable_type: object.class.to_s
    }

    !ReportedContent.where(criteria).exists?
  end
end
