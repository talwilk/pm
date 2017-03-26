require 'rails_helper'

describe GuruInvitationForm do
  it 'form is valid when attributes are valid' do
    form = GuruInvitationForm.new(email: "example@example.com")

    expect(form.valid?).to eq(true)
  end

  it 'form is invalid when email is missing' do
    form = GuruInvitationForm.new(email: "")
    expect(form.valid?).to eq(false)
  end

  it 'form is invalid when email has wrong format' do
    form = GuruInvitationForm.new(email: "example@example")
    expect(form.valid?).to eq(false)
  end

  it 'form is invalid when email is taken by existing guru' do
    create :user, email: 'first@user.email', role: 'guru'
    form = GuruInvitationForm.new(email: "first@user.email")

    expect(form.valid?).to eq(false)
  end

  it 'form is invalid when email belongs to deleted guru' do
    create :user, email: 'second@user.email', role: 'guru', deleted_at: Time.zone.now - 1.day
    form = GuruInvitationForm.new(email: "second@user.email")

    expect(form.valid?).to eq(false)
  end
end
