class AcceptGuruApplicationService
  attr_reader :guru_application

  def initialize(guru_application, super_admin)
    @guru_application = guru_application
    @super_admin = super_admin
  end

  def call
    update_application_and_user
    send_email
    true
  end

  private

  def update_application_and_user
    @guru_application.user.update_attribute(:role, 'guru')
    @guru_application.user.save
    @guru_application.update_attribute(:accepted_at, Time.zone.now)
    @guru_application.update_attribute(:resulter_id, @super_admin.id)
    @guru_application.save
  end

  def send_email
    UserMailer.guru_application_accepted(@guru_application.user).deliver_now
  end
end
