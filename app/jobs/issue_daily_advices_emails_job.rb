# Email No. 9

class IssueDailyAdvicesEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    # new_dilemma_advices_count will hold number of dilemma advices created during last 24 hours
    dilemmas = Dilemma.select("dilemmas.*, COUNT(dilemma_advices.id) as new_dilemma_advices_count").
      joins(:advices).where('dilemma_advices.created_at >= ?', Time.zone.now - 1.day).
      where('dilemma_advices.created_at <= ?', Time.zone.now).
      group("dilemmas.id")

    dilemmas.each do |dilemma|
      UserMailer.daily_advices(dilemma.user, dilemma, dilemma.new_dilemma_advices_count).deliver_later
    end
  end
end
