class SessionsController < Devise::SessionsController
  before_filter :reopen_account_if_deleted!
  before_action :set_failure_login_attempt, only: [:create]

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in)
    set_successful_login_attempt(resource.id)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  protected

  def reopen_account_if_deleted!
    if params[:reopen_account_token].presence

      token_validation_service = ValidateUserReopenAccountTokenService.new(params[:reopen_account_token])

      if token_validation_service.call

        reopen_account_service = ReopenAccountService.new(params[:reopen_account_token])

        if reopen_account_service.call
          flash[:notice] =t(:welcome_back)
        else
          flash[:warning] =t(:something_went_wrong_try_again)
        end
      else
        flash[:warning] = token_validation_service.error
      end
    end
  end

  private

  def set_failure_login_attempt
    @login_attempt = LoginHistory.new
    @login_attempt.current_sign_in_ip = request.remote_ip
    @login_attempt.login_method = 'email'
    @login_attempt.successful_login = false
    user = User.find_by(email: params[:user] ? params[:user][:email] : nil)
    if user.present?
      @login_attempt.user_id = user.id
      save_login_attempt
    end
  end

  def set_successful_login_attempt(user_id)
    @login_attempt.successful_login = true
    @login_attempt.user_id = user_id
    save_login_attempt
  end

  def save_login_attempt
    @login_attempt.save
  end
end
