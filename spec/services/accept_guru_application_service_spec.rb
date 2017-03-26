require 'rails_helper'

describe AcceptGuruApplicationService do
  it 'successfully accepts guru application' do
    user = create :user, email: 'guru@candidate.email'
    guru_application = create :guru_application, user: user
    super_admin = create :super_admin

    result = AcceptGuruApplicationService.new(guru_application, super_admin).call

    expect(result).to eq(true)
    expect(guru_application.accepted_at).not_to eq(nil)
    expect(guru_application.user.role).to eq("guru")
  end
end
