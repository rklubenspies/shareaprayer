# Stores users
# 
# @since 1.0.0
# @author Robert Klubenspies
class User < ActiveRecord::Base
  # @!attribute name
  #   @return [String] user's full name

  # @!attribute email
  #   @return [String] user's email address
  #   @see This is usually provided by Facebook on sign up

  # @!attribute roles
  #   @return [Array] representation of user's roles on SAP
  #   @note Used by easy_role gem
  #   @see https://github.com/platform45/easy_roles easy_roles gem
  #     documentation

  # @!attribute facebook_id
  #   @return [Integer] user's Facebook UID

  # @!attribute facebook_token
  #   @return user's Facebook access token, usually used to verify login
  #     or execute offline Graph API queries

  attr_accessible :name, :email, :roles, :facebook_id, :facebook_token
  easy_roles :roles
  has_many :church_memberships, dependent: :destroy
  has_many :churches, through: :church_memberships
  has_many :requests, dependent: :destroy
  has_many :prayers, dependent: :destroy
  has_many :reported_content, as: :owner, dependent: :destroy

  # @comment This enforces a default role of "invisible" on all entries
  #   created without roles. We couldn't set the default in the migration
  #   because roles are saved as a String, but adding a role creates a
  #   String representation of an Array to be saved to the database.
  before_validation(on: :create) do
    self.roles = ["invisible"] if !attribute_present?("roles")
  end

  # Adds a user as a member of a church
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] church_id the id of the church which the user is joining
  # @param [Array] roles the roles of the user in the church
  # @return [ChurchMembership] the newly created ChurchMembership object
  # @raise [UserNotSignedUp] if the user is not a signed up user
  # @raise [UserAlreadyChurchMember] if the user already belongs to the church
  def join_church(church_id, roles = ["member"])
    user = self

    raise "UserNotSignedUp" if !user.roles.include?("user")
    raise "UserAlreadyChurchMember" if ChurchMembership.where(user_id: user.id, church_id: church_id).exists?

    ChurchMembership.create!(user_id: user.id, church_id: church_id, roles: roles)
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
  def post_request(opts, church_id = nil)
    user = self

    raise "UserNotChurchMember" if user.is_not_church_member?(church_id) && church_id != nil

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
  # @param [Hash] opts a the options to create a request with
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
