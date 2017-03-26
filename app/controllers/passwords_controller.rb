class PasswordsController < Devise::PasswordsController
	before_action :require_no_authentication
  layout 'application', only: [:new, :create]

  private
  def require_no_authentication
    if user_signed_in?
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to after_sign_in_path_for(:user)
    end
  end
end
