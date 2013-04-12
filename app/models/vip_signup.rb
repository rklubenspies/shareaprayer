class VipSignup < ActiveRecord::Base
  attr_accessible :address, :bio, :code, :name, :phone, :rep_uid,
                  :subdomain, :website

  validates :code, presence: true, uniqueness: true


  state_machine :state, initial: :pending do
    event :sign_up_complete do
      transition :pending => :complete
    end
  end

  # Create a VIP signup
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] opts the options to register a church with
  # @option opts [String] :name the name of the church
  # @option opts [String] :subdomain the church's subdomain
  # @option opts [String] :bio the church's bio
  # @option opts [String] :address the church's address
  # @option opts [String] :phone the church's phone number
  # @option opts [String] :website the church's website
  # @option [String] rep_uid the representative that will take credit
  # @return [VipSignup]
  def self.generate(opts = {}, rep_uid = nil)
    opts[:code] = self.generate_code
    opts[:rep_uid] = rep_uid

    VipSignup.create(opts)
  end

  # Create a Church from a VIP signup
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @param [Hash] alterations the options to change from the VIP signup
  # @option alterations [String] :name the name of the church
  # @option alterations [String] :subdomain the church's subdomain
  # @option alterations [String] :bio the church's bio
  # @option alterations [String] :address the church's address
  # @option alterations [String] :phone the church's phone number
  # @option alterations [String] :website the church's website
  # @option [Integer] user_id the user signing up the church, who will
  #   also be the first manager
  # @return [Church]
  def create_church_with_alterations(alterations = {}, user_id)
    vip_signup = self

    possible_alterations = {
      name:       alterations[:name],
      subdomain:  alterations[:subdomain],
      bio:        alterations[:bio],
      address:    alterations[:address],
      phone:      alterations[:phone],
      website:    alterations[:website],
    }

    create_opts = {}

    # Create a hash of all the create opts
    possible_alterations.each do |key, opt|
      if vip_signup[key] != possible_alterations[key] && !possible_alterations[key].blank?
        create_opts[key] = possible_alterations[key]
      else
        create_opts[key] = vip_signup[key]
      end
    end

    church = Church.register(create_opts, user_id)

    if church
      vip_signup.sign_up_complete!
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
