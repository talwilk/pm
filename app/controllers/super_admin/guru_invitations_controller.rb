class SuperAdmin::GuruInvitationsController < SuperAdmin::BaseController
  def new
    @form = GuruInvitationForm.new
  end

  def create
    @form = GuruInvitationForm.new(invitation_params)

    service = GuruInvitationService.new(@form)

    if service.call
      redirect_to super_admin_users_path, notice: t(:invitation_sent_successfully)
    else
      render :new, notice: t(:something_went_wrong_try_again)
    end
  end

  private

  def invitation_params
    params.require(:guru_invitation_form).permit(:email)
  end
end
