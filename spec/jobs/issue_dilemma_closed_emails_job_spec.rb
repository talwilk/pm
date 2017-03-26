require "rails_helper"

describe IssueDilemmaClosedEmailsJob do
  it "send email about closed dilemma only once" do
    dilemma = create(:dilemma)

    travel_to(dilemma.ends_at + 1.hour) do
      ActionMailer::Base.deliveries.clear
      IssueDilemmaClosedEmailsJob.perform_later

      dilemma.reload

      expect(dilemma.closed_notification_sent).to eq(true)
      expect(ActionMailer::Base.deliveries.count).to eq(1)

      ActionMailer::Base.deliveries.clear
      IssueDilemmaClosedEmailsJob.perform_later

      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
end
