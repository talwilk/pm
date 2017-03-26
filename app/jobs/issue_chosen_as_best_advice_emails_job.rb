# Email No. 14

class IssueChosenAsBestAdviceEmailsJob < ActiveJob::Base
  queue_as :default

  def perform
    # Find dilemmas with favorite advice time period finished, with selected
    # favorite advice and which didn't have notification already send.
    dilemmas = Dilemma.where(reward_notification_sent: false).
      where("favorite_advice_ends_at <= ?", Time.zone.now).
      where.not(favorite_dilemma_advice_id: nil)

    dilemmas.each do |dilemma|
      favorite_dilemma_advice = dilemma.favorite_dilemma_advice

      reward = Gamification::BestDilemmaAdviceReward.new(favorite_dilemma_advice)
      reward.issue_reward

      UserMailer.chosen_as_best_advice(favorite_dilemma_advice.user, dilemma).deliver_later

      # Mark that we sent reward notification
      dilemma.update_attributes(reward_notification_sent: true)
    end
  end
end
