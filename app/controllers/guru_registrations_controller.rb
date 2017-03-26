class GuruRegistrationsController < ApplicationController
  before_action :require_no_authentication

  def new
    @guru_registration_form = GuruRegistrationForm.new(experience: "1_5_years")
  end

  def create
    @guru_registration_form = GuruRegistrationForm.new(user_params.merge({ip_address: request.remote_ip}))
    geo_service = ResolveGeolocationService.new(request.remote_ip)
    service = GuruRegistrationService.new(@guru_registration_form, request.remote_ip, geo_service.call)

    if service.call
      sign_in(User, service.user)
      set_login_attempt('guru_registration', true)
      redirect_to root_path, notice: t(:guru_application_successfully_created)
    else
      set_login_attempt('guru_registration', false)
      render :new
    end
  end

  private

  def user_params
    params.require(:guru_registration_form).permit(:email,
      :password,
      :username,
      :first_name,
      :last_name,
      :address,
      :mobile_number,
      :mantra,
      :experience,
      category_list: []
    )
  end

  def set_login_attempt(method, successful)
    if current_user
      login_attempt = LoginHistory.new
      login_attempt.current_sign_in_ip = request.remote_ip
      login_attempt.login_method = method
      login_attempt.successful_login = successful
      login_attempt.user_id = current_user.id
      login_attempt.save
    end
  end

  def require_no_authentication
    if user_signed_in?
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(:user)
    end
  end
end
