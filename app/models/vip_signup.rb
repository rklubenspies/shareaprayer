class VipSignup < ActiveRecord::Base
  attr_accessible :address, :bio, :code, :name, :phone, :rep_uid,
                  :subdomain, :website, :plan_id, :sales_notes

  validates :code, presence: true, uniqueness: true

  has_one :church
  belongs_to :plan

  state_machine :state, initial: :pending do
    event :sign_up_complete do
      transition :pending => :complete
    end

    event :user_cancelled do
      transition all - [:user_cancelled] => :user_cancelled
    end
  end

  # Create a VIP signup
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] plan_id the id of the Plan for this signup. Do not
  #   confuse for the Braintree plan identifier (i.e. "50-members").
  # @param [Hash] opts the options to register a church with
  # @option opts [String] :name the name of the church
  # @option opts [String] :subdomain the church's subdomain
  # @option opts [String] :bio the church's bio
  # @option opts [String] :address the church's address
  # @option opts [String] :phone the church's phone number
  # @option opts [String] :website the church's website
  # @option [String] rep_uid the representative that will take credit
  # @option [String] sales_notes publiclly displayed nots on signup
  # @return [VipSignup]
  def self.generate(plan_id, opts = {}, rep_uid = nil, sales_notes = nil)
    opts[:plan_id] = plan_id
    opts[:code] = self.generate_code
    opts[:rep_uid] = rep_uid
    opts[:sales_notes] = sales_notes

    vip = VipSignup.create(opts)

    vip
  end

  # Create a Church from a VIP signup
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] data the options to change from the VIP signup
  # @option data [String] :name the name of the church
  # @option data [String] :subdomain the church's subdomain
  # @option data [String] :bio the church's bio
  # @option data [String] :address the church's address
  # @option data [String] :phone the church's phone number
  # @option data [String] :website the church's website
  # @param [Hash] payment the secured payment information
  # @option data [String] :number
  # @option data [String] :expiration_month
  # @option data [String] :expiration_year
  # @option data [String] :cvv
  # @option [Integer] user_id the user signing up the church, who will
  #   also be the first manager
  # @raise [CouldNotCompleteSignup] if something went wrong with
  #   creating the Braintree customer, was not caught by that method,
  #   and caused us not to be able to run `vip_signup.complete!`.
  # @return [Church]
  def setup_church(data = {}, payment = {}, user_id)
    vip_signup = self

    create_opts = {
      profile_picture:  data[:profile_picture],
      vip_signup_id:    vip_signup.id,
    }
    
    possible_alterations = {
      name:       data[:name],
      subdomain:  data[:subdomain],
      bio:        data[:bio],
      address:    data[:address],
      phone:      data[:phone],
      website:    data[:website],
    }
    
    possible_alterations.each do |key, opt|
      if vip_signup[key] != possible_alterations[key] && !possible_alterations[key].blank?
        create_opts[key] = possible_alterations[key]
      else
        create_opts[key] = vip_signup[key]
      end
    end

    church = Church.register(create_opts, user_id)

    if church
      customer_id = church.setup_braintree_customer(user_id, payment)
      
      if customer_id
        Subscription.setup(church.id, vip_signup.plan_id, customer_id)
        vip_signup.sign_up_complete!
      else
        raise "CouldNotCompleteSignup"
      end
    end

    church
  end

  # Generate a unique, random VIP signup code
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] length length of code in characters
  # @return [String]
  def self.generate_code(length = 4)
    code = self.random_code(length)
    
    # Use a while block to ensure the uniqueness of the code
    while VipSignup.where(code: code).exists?
      code = self.random_code(length)
    end

    code
  end

  # Generate a random code
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Integer] length length of code in characters
  # @return [String]
  def self.random_code(length = 4)
    characters = ('A'..'Z').to_a + ('0'..'9').to_a

    code = SecureRandom.random_bytes(length).each_char.map do |char|
      characters[(char.ord % characters.length)]
    end.join
  end
end
