require 'rails_helper'

describe GuruInvitationService do
  it 'after successful invitation deliveries an email' do
    form = GuruInvitationForm.new(email: "example@example.com")

    expect do
      expect(GuruInvitationService.new(form).call).to eq(true)
    end.to change(UserMailer.deliveries, :count).by(1)
  end

  it 'unsuccessful guru invitation' do
    form = GuruInvitationForm.new(email: "invalid@email")

    expect do
      expect(GuruInvitationService.new(form).call).to eq(false)
    end.to change(UserMailer.deliveries, :count).by(0)
  end

  it 'with email already assigned to guru' do
    create :user, email: 'existing@guru.email', role: 'guru'
    form = GuruInvitationForm.new(email: "existing@guru.email")

    expect do
      expect(GuruInvitationService.new(form).call).to eq(false)
    end.to change(UserMailer.deliveries, :count).by(0)
  end

  it 'with email assigned to guru with deleted account' do
    create :user, email: 'deleted@guru.email', role: 'guru', deleted_at: Time.zone.now - 1.day
    form = GuruInvitationForm.new(email: "deleted@guru.email")

    expect do
      expect(GuruInvitationService.new(form).call).to eq(false)
    end.to change(UserMailer.deliveries, :count).by(0)
  end
end
