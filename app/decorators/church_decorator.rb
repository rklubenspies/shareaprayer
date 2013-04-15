class ChurchDecorator < Draper::Decorator
  delegate_all
  
  # Church's sidebar picture tag
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] an image tag containing photo
  def picture_tag
    # Fake it til you make it
    h.image_tag("live/samples/church.jpg")
  end

  # Church's name
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's name
  def name
    source.name
  end

  # Church's bio
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's bio
  def bio
    source.profile.bio
  end

  # Church's phone number (normalized and formatted)
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @see http://stackoverflow.com/a/5913838/483418
  # @return [String] the church's phone number
  def formatted_phone
    if source.profile.phone
      digits = source.profile.phone.gsub(/\D/, '').split(//)

      if (digits.length == 11 and digits[0] == '1')
        # Strip leading 1
        digits.shift
      end

      if (digits.length == 10)
        digits = digits.join
        return '(%s) %s-%s' % [ digits[0,3], digits[3,3], digits[6,4] ]
      else
        return digits
      end
    end
  end

  # Church's address as a hash
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [OpenStruct] the church's address, in it's component parts
  def raw_address
    if source.profile.address
      address = StreetAddress::US.parse(source.profile.address)

      OpenStruct.new(
        street:   address.to_s(:line1),
        city:     address.city,
        state:    address.state,
        zip:      address.postal_code
      )
    end
  end

  # Church's website in raw format (not linked)
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  def raw_website
    source.profile.website
  end
end