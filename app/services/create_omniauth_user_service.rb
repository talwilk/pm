class CreateOmniauthUserService
  attr_reader :oauth_user, :auth

  def initialize(auth, ip_request, geo_data)
    @auth = auth
    @ip = ip_request
    @geo_data = geo_data
  end

  def call
    if existing_user
      true
    else
      if existing_email
        save_oauth_user
        true
      else
        build_oauth_user
        save_oauth_user
      end
    end
  end

  private

  def build_oauth_user
    @oauth_user = User.new
    @oauth_user.password = Devise.friendly_token[0,20]
    @oauth_user.email = @auth.info['email']
    @oauth_user.registration_ip_address = @ip

    if @geo_data.empty?
      @oauth_user.country_iso = "RD"
      @oauth_user.additional_geolocation_info = {}.to_json
    else
      @oauth_user.country_iso = @geo_data.first.country_code
      @oauth_user.additional_geolocation_info = @geo_data.first.data.to_json
    end

    @oauth_user.build_profile
    case @auth.provider
      when 'google_oauth2'
        @oauth_user.google_oauth_uid = @auth.uid
      when 'facebook'
        @oauth_user.facebook_oauth_uid = @auth.uid
    end
  end

  def existing_user
    case @auth.provider
      when 'google_oauth2'
        @oauth_user = User.find_by(google_oauth_uid: @auth.uid)
      when 'facebook'
        @oauth_user = User.find_by(facebook_oauth_uid: @auth.uid)
    end
  end

  def existing_email
    @oauth_user = User.find_by(email: @auth.info.email)
    if @oauth_user.present?
      case @auth.provider
        when 'google_oauth2'
          @oauth_user.google_oauth_uid = @auth.uid
        when 'facebook'
          @oauth_user.facebook_oauth_uid = @auth.uid
      end
    end
  end

  def save_oauth_user
    @oauth_user.save
  end
end
