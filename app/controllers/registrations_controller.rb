class RegistrationsController < Devise::RegistrationsController
  layout 'application', only: :edit

  def create
    puts "*** in create registration"
    @project = Project.find_by(id: session[:new_project_id])
    @project.update_attributes(email: sign_up_params[:email]) if @project.present?
    if deleted_user
      reopen_token_service = SendReopenAccountTokenService.new(deleted_user)

      if reopen_token_service.call
        redirect_to root_path, notice: t(:account_reopening_link_sent)
      else
        redirect_to root_path, notice: t(:something_went_wrong_try_again)
      end
    else
      build_resource(sign_up_params)
      resource.build_profile(locale: I18n.locale, mobile_number: "0000000000")
      resource.registration_ip_address = request.remote_ip

      service = ResolveGeolocationService.new(request.remote_ip)
      geo_data = service.call
      puts "*** geo_data"

      if geo_data.empty?
        resource.country_iso = "IL"
        resource.additional_geolocation_info = {}.to_json
      else
        resource.country_iso = geo_data.first.country_code
        resource.additional_geolocation_info = geo_data.first.data.to_json
      end

      if resource.save
        puts "*** resource save"
        set_login_attempt("email", true, resource.id)
      end

      yield resource if block_given?

      if resource.persisted?
        puts "*** resource persisted"
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end

  private

  def deleted_user
    User.only_deleted.find_by_email(params[:user][:email])
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
