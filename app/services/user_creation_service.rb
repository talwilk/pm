class UserCreationService
  attr_reader :user

  def initialize(user_info, ip_request, geo_data)
    @user_info = user_info
    @ip = ip_request
    @geo_data = geo_data
  end

  def call
    return false unless @user_info.valid?
    build_user
    build_user_profile
    save_user
    return true
  end

  private

  def build_user
    @user = User.new(@user_info.user_attributes)
    @user.registration_ip_address = @ip

    if @geo_data.empty?
      @user.country_iso = "IL"
      @user.additional_geolocation_info = {}.to_json
    else
      @user.country_iso = @geo_data.first.country_code
      @user.additional_geolocation_info = @geo_data.first.data.to_json
    end
  end

  def build_user_profile
    @user.build_profile(@user_info.user_profile_attributes)
  end

  def save_user
    @user.save!
  end
end