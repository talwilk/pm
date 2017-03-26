# Email No. 11

class IssueFavoriteAdviceReminderEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    dilemmas = Dilemma.where(favorite_dilemma_advice_id: nil).
      where('favorite_advice_ends_at >= ?', Time.zone.now).
      where('ends_at <= ?', Time.zone.now)

    dilemmas.each do |dilemma|
      UserMailer.favorite_advice_reminder(dilemma.user, dilemma).deliver_now
    end
  end
end
