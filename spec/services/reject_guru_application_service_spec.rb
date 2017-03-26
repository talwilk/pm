require "rails_helper"

describe RejectGuruApplicationService do
  it "successfully rejects guru application" do
    user = create(:user, email: "guru@candidate.email")
    guru_application = create(:guru_application, user: user)
    super_admin = create(:super_admin)

    UserMailer.deliveries.clear
    expect(RejectGuruApplicationService.new(guru_application, super_admin).call).to eq(true)

    expect(UserMailer.deliveries.count).to eq(1)
    expect(guru_application).not_to eq(nil)
  end
end
