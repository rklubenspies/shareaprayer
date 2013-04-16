class ChurchSubdomain  
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != ('www' || 'api')
  end  
end