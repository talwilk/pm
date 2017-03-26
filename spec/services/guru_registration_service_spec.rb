require 'rails_helper'

describe GuruRegistrationService do
  def default_registration_attributes(overwrites = {})
    {
      email: "example@example.com",
      password: "password",
      experience: "1_5_years",
      category_list: ["kids"],
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      address: Faker::Address.city,
      mobile_number: "+48123789423",
      mantra: Faker::Lorem.sentence
    }.merge(overwrites)
  end

  def default_geodata
    double("geodata", empty?: false, first: double(
      "geodata 1",
      data: {},
      country_code: "US"
    ))
  end

  it 'after successful registration changes users count, guru applications count and deliveries 3 emails' do
    Country.create(country_iso: "US", enabled_at: Time.zone.now)
    form = GuruRegistrationForm.new(default_registration_attributes)

    expect do
      expect(GuruRegistrationService.new(form, '1.2.3.4', default_geodata).call).to eq true
    end.to change(User, :count).by(1).and change(UserProfile, :count).by(1).and change(GuruApplication, :count).by(1).and change(UserMailer.deliveries, :count).by(2)
  end

  it 'with invalid form' do
    Country.create(country_iso: "US", enabled_at: Time.zone.now)
    form = GuruRegistrationForm.new(default_registration_attributes(email: "invalid@email"))

    expect do
      expect(GuruRegistrationService.new(form, '1.2.3.4', default_geodata).call).to eq false
    end.to change(User, :count).by(0).and change(UserProfile, :count).by(0).and change(GuruApplication, :count).by(0).and change(UserMailer.deliveries, :count).by(0)
  end

  it 'with taken email' do
    Country.create(country_iso: "US", enabled_at: Time.zone.now)
    create(:user, email: 'existing@user.email')
    form = GuruRegistrationForm.new(default_registration_attributes(email: "existing@user.email"))

    expect do
      expect(GuruRegistrationService.new(form, '1.2.3.4', default_geodata).call).to eq false
    end.to change(User, :count).by(0).and change(UserProfile, :count).by(0).and change(GuruApplication, :count).by(0).and change(UserMailer.deliveries, :count).by(0)
  end

  it 'after deleting account' do
    Country.create(country_iso: "US", enabled_at: Time.zone.now)
    create(:user, email: 'deleted@user.email', deleted_at: Time.zone.now - 1.day)
    form = GuruRegistrationForm.new(default_registration_attributes(email: "deleted@user.email"))

    expect do
      expect(GuruRegistrationService.new(form, '1.2.3.4', default_geodata).call).to eq false
    end.to change(User, :count).by(0).and change(UserProfile, :count).by(0).and change(GuruApplication, :count).by(0).and change(UserMailer.deliveries, :count).by(0)
  end

  it "sets reserved country when geocoding service is not available" do
    Country.create(country_iso: "US", enabled_at: Time.zone.now)
    # Geocoder.search returns empty array when ip address cannot be resolved
    geodata = []

    form = GuruRegistrationForm.new(default_registration_attributes(email: "deleted@user.email"))
    service = GuruRegistrationService.new(form, '1.2.3.4', geodata)

    service.call
    user = User.last

    expect(user.country_iso).to eq("RD")
  end
end
