class CatchallSubdomain
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != "www" && request.subdomain != "live"
  end
end