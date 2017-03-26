# Email No. 10

class IssueDilemmaClosedEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    dilemmas = Dilemma.where(closed_notification_sent: false).
      where("ends_at <= ?", Time.zone.now)

    dilemmas.each do |dilemma|
      UserMailer.dilemma_closed(dilemma.user, dilemma).deliver_later

      dilemma.update_attributes(closed_notification_sent: true)
    end
  end
end
