require "rails_helper"

describe StartGuruApplicationReviewService do
  it "successfully started review" do
    user = create(:user, email: "guru@candidate.email")
    guru_application = create(:guru_application, user: user)
    super_admin = create(:super_admin)

    result = StartGuruApplicationReviewService.new(guru_application, super_admin).call

    expect(result).to eq(true)
    expect(guru_application.review_started_at).not_to eq(nil)
  end
end
