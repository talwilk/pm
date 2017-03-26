class ConfirmationsController < Devise::ConfirmationsController
  before_action :authenticate_user!, only: [:resend_token]
  def resend_token
    regenerate_confirmation_token(current_user)
    if UserMailer.resend_confirmation(current_user, current_user.confirmation_token).deliver_now
      flash[:notice] = t(:confirmation_token_resend_successfully)
      redirect_to root_url
    else
      flash[:info] = t(:confirmation_token_resend_unsuccessfully)
      redirect_to root_url
    end
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      flash[:confirmed] = _('AlertMessage|render_confirmation_modal')
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      flash[:error] = resource.errors.full_messages.first

      if user_signed_in?
        redirect_to root_path
      else
        redirect_to new_session_path(resource)
      end
    end
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    if Country.find(@user.country_iso).enabled_at.nil?
      if signed_in?(resource_name)
        root_url(resource)
      else
        sign_in(resource)
        root_url(resource)
      end
    else
      if signed_in?(resource_name)
        new_dilemma_url
      else
        sign_in(resource)
        new_dilemma_url
      end
    end
  end

  def regenerate_confirmation_token(user)
    user.confirmation_token = Devise.friendly_token
    user.confirmation_sent_at = Time.zone.now
    user.save
  end
end
