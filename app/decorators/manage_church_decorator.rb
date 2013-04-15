class ManageChurchDecorator < ChurchDecorator
  delegate_all
  
  # Church's address formatted for inline output
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's address
  def inline_address
    if raw_address
      "#{raw_address.street}, #{raw_address.city}, #{raw_address.state} #{raw_address.zip}"
    end
  end
end