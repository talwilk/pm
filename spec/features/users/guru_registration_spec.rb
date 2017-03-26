require 'rails_helper'

feature 'Guru signs up' do
  scenario 'with valid attributes' do
    guru_registration_page = Page::User::Guru::GuruRegistration.new
    guru_registration_page.visit

    guru_registration_page.fill_in(
      email: 'new@user.email',
      password: "good_password",
      first_name: 'John',
      last_name: 'Smith',
      mantra: Faker::Lorem.sentence
    )
    select '1 to 5 years', from: 'Experience'
    select 'Air conditioning', from: 'Category list', visible: false
    select 'Cladding', from: 'Category list', visible: false
    guru_registration_page.submit

    expect(User).to exist(email: 'new@user.email')
    expect(UserProfile).to exist(first_name: 'John', last_name: 'Smith')
    user_profile = UserProfile.last
    expect(user_profile.category_list.sort).to eq(%w(cladding air_conditioning).sort)
  end

  scenario 'with invalid attributes' do
    guru_registration_page = Page::User::Guru::GuruRegistration.new
    guru_registration_page.visit

    guru_registration_page.fill_in(
      email: "invalid.email",
      password: "short",
      first_name: "",
      last_name: ""
    )
    guru_registration_page.submit

    expect(guru_registration_page).to have_invalid_email_alert
  end
end
