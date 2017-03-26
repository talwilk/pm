require "rails_helper"

describe IssueChosenAsBestAdviceEmailsJob do
  it "sends email about best advice only once" do
    dilemma = create(:dilemma)
    good_advice = create(:dilemma_advice, dilemma: dilemma)
    bad_advice = create(:dilemma_advice, dilemma: dilemma)

    dilemma.update_attributes(favorite_dilemma_advice_id: good_advice.id)

    travel_to(dilemma.favorite_advice_ends_at + 1.hour) do
      ActionMailer::Base.deliveries.clear
      IssueChosenAsBestAdviceEmailsJob.perform_now

      dilemma.reload

      expect(dilemma.reward_notification_sent).to eq(true)
      # expect 2 emails, one for dilemma author, one for advice author
      expect(ActionMailer::Base.deliveries.count).to eq(2)

      ActionMailer::Base.deliveries.clear
      IssueChosenAsBestAdviceEmailsJob.perform_now

      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end

  it "do not send email when favorite advice is not chosen" do
    dilemma_without_favorite_advice = create(:dilemma)
    create(:dilemma_advice, dilemma: dilemma_without_favorite_advice)

    travel_to(dilemma_without_favorite_advice.favorite_advice_ends_at + 1.hour) do
      ActionMailer::Base.deliveries.clear
      IssueChosenAsBestAdviceEmailsJob.perform_now

      dilemma_without_favorite_advice.reload

      expect(dilemma_without_favorite_advice.reward_notification_sent).to eq(false)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
end
