require 'rails_helper'

feature 'Super admin visits users tab', js:true do
  let!(:super_admin)              { create :super_admin }
  let!(:user)                     { create :confirmed_user, id: 1, signup_way: 'guru', country_iso: 'PL' }
  let!(:second_user)              { create :user, id: 2, signup_way: 'guru', country_iso: 'PL', role: 'guru' }
  let!(:user_profile)             { create :user_profile, user: user,
                                                          last_name: 'Johnson'
                                                        }
  let!(:second_user_profile)      { create :user_profile, user: second_user,
                                                          category_list: ['kids', 'kitchen_design'],
                                                          last_name: 'Smith'
                                                        }
  let(:index_page)     { Page::SuperAdmin::Users::Index.new }
  let(:edit_page)      { Page::SuperAdmin::Users::Edit.new(user) }
  let(:home_page)      { Page::User::Home.new }

  before do
    sign_in(super_admin)
  end

  scenario 'and uses search bar' do
    index_page.visit
    expect(index_page).to have_text(user.email)
    expect(index_page).to have_text(second_user.email)

    index_page.fill_in 'search', with: user.email + 'x'
    index_page.search
    expect(index_page).to have_content 'No results found'

    index_page.fill_in 'search', with: user.email
    index_page.search
    expect(index_page).to have_content 'Search results: (1)'
    expect(index_page).to have_content user.email
  end

  scenario 'and uses filters' do
    index_page.visit
    expect(index_page).to have_text(user.email)
    expect(index_page).to have_text(second_user.email)

    index_page.select 'Regular user', from: 'user_type_filter'
    index_page.search
    expect(index_page).to have_content 'Search results: (1)'
    expect(index_page).to have_content user.email

    index_page.select 'Guru', from: 'user_type_filter'
    index_page.search
    expect(index_page).to have_content 'Search results: (1)'
    expect(index_page).to have_content second_user.email

    index_page.select 'All', from: 'user_type_filter'
    index_page.select 'Poland', from: 'user_country_filter'
    index_page.search
    expect(index_page).to have_content 'Search results: (2)'
    expect(index_page).to have_content user.email
  end

  scenario 'edits profile' do
    Country.create(country_iso: "FR", enabled_at: Time.zone.now)
    edit_page.visit

    edit_page.fill_in(
      {
        email: 'newemail@example.com',
        username: 'newusername',
        country_iso: 'FR',
        profile_attributes: {
          first_name: 'New first name',
          last_name: 'New last name',
          mobile_number: '48777888333',
          mantra: 'New mantra'
        }
      }
    )

    edit_page.save

    user.reload
    expect(user.email).to eq('newemail@example.com')
    expect(user.username).to eq('newusername')
    expect(user.country_iso).to eq('FR')
    expect(user.profile.first_name).to eq('New first name')
    expect(user.profile.last_name).to eq('New last name')
    expect(user.profile.mobile_number).to eq('48777888333')
    expect(user.profile.mantra).to eq('New mantra')
  end
end
