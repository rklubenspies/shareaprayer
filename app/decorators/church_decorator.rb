class ChurchDecorator < Draper::Decorator
  delegate_all

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
  def phone
    if source.profile.phone
      digits = source.profile.phone.gsub(/\D/, '').split(//)

      if (digits.length == 11 and digits[0] == '1')
        # Strip leading 1
        digits.shift
      end

      if (digits.length == 10)
        digits = digits.join
        '(%s) %s-%s' % [ digits[0,3], digits[3,3], digits[6,4] ]
      end

      return digits
    end
  end

  # Church's address
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's address
  def address
    if source.profile.address
      address = StreetAddress::US.parse(source.profile.address)
      output = "#{address.to_s(:line1)}\n#{address.city}, #{address.state} #{address.postal_code}"
      return h.sanitize(output.gsub("\n", "<br>").html_safe, :tags => ["br"])
    end
  end

  # Church's website
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] the church's website
  def website
    if source.profile.website
      return h.link_to(source.profile.website, source.profile.website)
    end
  end

  # Church's sidebar pic
  # 
  # @since 1.0.0
  # @author Robert Klubenspies
  # @return [String] an image tag containing photo
  def picture
    # Fake it til you make it
    h.image_tag("live/samples/church.jpg")
  end
end
