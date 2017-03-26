class GuruInvitationService
  attr_reader :invitation_form

  def initialize(invitation_form)
    @invitation_form = invitation_form
  end

  def call
    return false unless @invitation_form.valid?

    send_guru_invitation_email

    true
  end

  private

  def send_guru_invitation_email
    UserMailer.guru_invitation(@invitation_form).deliver_now
  end
end
