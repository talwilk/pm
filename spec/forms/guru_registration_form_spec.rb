require 'rails_helper'

describe GuruRegistrationForm do
  def default_registration_attributes(overwrites)
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

  it 'form is valid when attributes are valid' do
    form = GuruRegistrationForm.new(default_registration_attributes(email: "example@example.com"))
    expect(form.valid?).to eq true
  end

  it 'form is invalid when email is missing' do
    form = GuruRegistrationForm.new(default_registration_attributes(email: ""))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when email has wrong format' do
    form = GuruRegistrationForm.new(default_registration_attributes(email: "example@example"))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when password is missing' do
    form = GuruRegistrationForm.new(default_registration_attributes(password: ""))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when password is too short' do
    form = GuruRegistrationForm.new(default_registration_attributes(password: "1234567"))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when password is too long' do
    form = GuruRegistrationForm.new(default_registration_attributes(password: SecureRandom.hex(37)))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when experience is missing' do
    form = GuruRegistrationForm.new(default_registration_attributes(experience: ""))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when experience is invalid' do
    form = GuruRegistrationForm.new(default_registration_attributes(experience: "100000_years"))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when categories are missing' do
    form = GuruRegistrationForm.new(default_registration_attributes(category_list: []))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when categories are invalid' do
    form = GuruRegistrationForm.new(default_registration_attributes(category_list: ["invalid_category"]))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when email is taken' do
    create :user, email: 'first@user.email'
    form = GuruRegistrationForm.new(default_registration_attributes(email: "first@user.email"))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when email belongs to deleted user' do
    create :user, email: 'second@user.email', deleted_at: Time.zone.now - 1.day
    form = GuruRegistrationForm.new(default_registration_attributes(email: "second@user.email"))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when first name is missing' do
    form = GuruRegistrationForm.new(default_registration_attributes(first_name: ""))
    expect(form.valid?).to eq false
  end

  it 'form is invalid when last name is missing' do
    form = GuruRegistrationForm.new(default_registration_attributes(last_name: ""))
    expect(form.valid?).to eq false
  end
end
