class ResolveGeolocationService
  attr_reader :ip_address

  def initialize(ip_address)
    @ip_address = ip_address
  end

  def call
    get_geocode_info
  end

  private

  def get_geocode_info
    geo_data = Geocoder.search(@ip_address.to_s)
    geo_data
  end
end
