class GuruRegistrationService
  attr_reader :guru_registration_form, :user

  def initialize(guru_registration_form, ip_request, geo_data)
    @guru_registration_form = guru_registration_form
    @ip = ip_request
    @geo_data = geo_data
  end

  def call
    return false unless @guru_registration_form.valid?
    build_user
    build_user_profile
    save_user
    save_guru_application
    send_email_to_admin
    return true
  end

  private

  def build_user
    @user = User.new(@guru_registration_form.guru_attributes)
    @user.registration_ip_address = @ip

    if @geo_data.empty?
      @user.country_iso = "RD"
      @user.additional_geolocation_info = {}.to_json
    else
      @user.country_iso = @geo_data.first.country_code
      @user.additional_geolocation_info = @geo_data.first.data.to_json
    end
  end

  def build_user_profile
    @user.build_profile(@guru_registration_form.user_profile_attributes)
  end

  def save_user
    @user.save!
  end

  def save_guru_application
    @guru_application = @user.guru_applications.create(
      form_hash: @guru_registration_form.serializable_hash.except(:password).to_json,
      application_ip: @guru_registration_form.ip_address
    )
  end

  def send_email_to_admin
    SuperadminMailer.new_guru_candidate(@user).deliver_now
  end
end
