class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_gettext_locale
  before_filter :update_last_sign_in_at
  before_action :set_guest_user_country
  before_action :set_locale
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def set_locale
    I18n.locale = I18n.default_locale
    if language_change_necessary?
      I18n.locale = the_new_locale
      locale_cookie(I18n.locale)
      I18n.default_locale = the_new_locale
      #use_locale_from_cookie
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      sanitized_params = %i(
        email
        experience
        category_list
        username
        password
        password_confirmation
        current_password
      )
      u.permit(sanitized_params)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      sanitized_params = %i(
        email
        experience
        category_list
        username
        password
        password_confirmation
        current_password
      )
      u.permit(sanitized_params)
    end
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end

  def set_guest_user_country
    if current_user.nil?
      guest_ip = request.remote_ip
      geo_data = Geocoder.search(guest_ip)

      session[:country_iso] = geo_data.empty? ? "RD" : geo_data.first.country_code
    end
  end

  def language_change_necessary?
    cookies['locale'].nil? || params[:locale]
  end

  def the_new_locale
    new_locale = (params[:locale]) #|| extract_locale_from_accept_language_header)
    %w(he en).include?(new_locale) ? new_locale : I18n.default_locale.to_s
  end

  def locale_cookie(locale)
    cookies['locale'] = locale.to_s
  end

  def use_locale_from_cookie
    I18n.locale = cookies['locale']
  end

  # def extract_locale_from_accept_language_header
  #   request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  # rescue
  #   I18n.default_locale
  # end

  protected

  def update_last_sign_in_at
    if user_signed_in? && !session[:logged_signin]
      sign_in(current_user, :force => true)
      session[:logged_signin] = true
    end
  end
end
