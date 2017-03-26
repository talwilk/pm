class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    if user && !user.deleted_at.nil?
      send_reopen_account_token
      return
    end

    geo_service = ResolveGeolocationService.new(request.remote_ip)
    service = CreateOmniauthUserService.new(request.env['omniauth.auth'],request.remote_ip, geo_service.call)

    if service.call
      set_login_attempt('facebook', true, service.oauth_user.id)
      sign_in_and_redirect service.oauth_user, event: :authentication
    else
      set_login_attempt('facebook', false, service.oauth_user.id)
      session['devise.facebook_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    if user && !user.deleted_at.nil?
      send_reopen_account_token
      return
    end

    geo_service = ResolveGeolocationService.new(request.remote_ip)
    service = CreateOmniauthUserService.new(request.env['omniauth.auth'],request.remote_ip, geo_service.call)

    if service.call
      set_login_attempt('google+', true, service.oauth_user.id)
      sign_in_and_redirect service.oauth_user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      set_login_attempt('google+', false, service.oauth_user.id)
      redirect_to new_user_registration_url
    end
  end

  private

  def send_reopen_account_token
    reopen_token_service = SendReopenAccountTokenService.new(user)

    if reopen_token_service.call
      redirect_to root_path, notice: t(:account_reopening_link_sent)
    end
  end

  def user
    @user ||= User.with_deleted.find_by_email(request.env['omniauth.auth'].info.email)
  end

  def set_login_attempt(method, successful, user_id)
    login_attempt = LoginHistory.new
    login_attempt.current_sign_in_ip = request.remote_ip
    login_attempt.login_method = method
    login_attempt.successful_login = successful
    login_attempt.user_id = user_id
    login_attempt.save
  end
end
