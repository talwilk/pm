class RejectGuruApplicationService
  attr_reader :guru_application

  def initialize(guru_application, super_admin)
    @guru_application = guru_application
    @super_admin = super_admin
  end

  def call
    update_guru_application
    send_email
    true
  end

  private

  def update_guru_application
    @guru_application.update_attribute(:rejected_at, Time.zone.now)
    @guru_application.update_attribute(:resulter_id, @super_admin.id)
    @guru_application.save
  end

  def send_email
    UserMailer.guru_application_rejected(@guru_application.user).deliver_now
  end
end
