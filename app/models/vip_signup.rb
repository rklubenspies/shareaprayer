# TODO: ADD STATUS COLUMN AND TRACK SIGNED UP OR NOT SIGNED UP (FOR SALES)

class VipSignup < ActiveRecord::Base
  attr_accessible :address, :bio, :code, :name, :phone, :rep_uid,
                  :subdomain, :website

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
