class SuperadminMailer < ActionMailer::Base
  default from: ENV['DEVISE_MAILER_SENDER']

  def new_guru_candidate(user)
    @user = user

    mail to: 'admin@example.com', subject: I18n.t("emails.super_admin_mailer.new_person_wants_to_be_a_guru") # TODO: fill in admins e-mail
  end
end
