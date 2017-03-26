require 'rails_helper'

feature 'Super admin visits guru applications tab' do
  scenario 'and uses search bar' do
    super_admin             = create :super_admin

    user                    = build :user, signup_way: 'guru'
    user_profile            = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Johnson'
    user.profile = user_profile
    user.save!

    second_user             = build :user, signup_way: 'guru'
    second_user_profile     = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Smith'
    second_user.profile = second_user_profile
    second_user.save!

    guru_application        = create :guru_application, user: user
    second_guru_application = create :guru_application, user: second_user, review_started_at: Time.zone.now - 10.minutes

    guru_applications_tab   = Page::SuperAdmin::GuruApplicationsTab.new

    sign_in(super_admin)
    guru_applications_tab.visit
    expect(guru_applications_tab).to have_content 'Smith'
    expect(guru_applications_tab).to have_content 'Johnson'
    fill_in 'search', with: 'MacDonald'
    guru_applications_tab.search
    expect(guru_applications_tab).to have_content 'No results found'
    fill_in 'search', with: 'Smith'
    guru_applications_tab.search
    expect(guru_applications_tab).to have_content 'Search results: (1)'
    expect(guru_applications_tab).to have_content 'Smith'
  end

  scenario 'and uses filter' do
    super_admin             = create :super_admin

    user                    = build :user, signup_way: 'guru'
    user_profile            = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Johnson'
    user.profile = user_profile
    user.save

    second_user             = build :user, signup_way: 'guru'
    second_user_profile     = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Smith'
    second_user.profile = second_user_profile
    second_user.save

    guru_application        = create :guru_application, user: user
    second_guru_application = create :guru_application, user: second_user, review_started_at: Time.zone.now - 10.minutes

    guru_applications_tab   = Page::SuperAdmin::GuruApplicationsTab.new

    sign_in(super_admin)
    guru_applications_tab.visit
    expect(guru_applications_tab).to have_content 'Smith'
    expect(guru_applications_tab).to have_content 'Johnson'
    select 'Being reviewed', from: 'guru_app_filter'
    guru_applications_tab.search
    expect(guru_applications_tab).to have_content 'Smith'
    expect(guru_applications_tab).not_to have_content 'Johnson'
  end

  scenario 'and views one of the applications' do
    super_admin             = create :super_admin

    user                    = build :user, signup_way: 'guru'
    user_profile            = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Johnson'
    user.profile = user_profile
    user.save

    guru_application        = create :guru_application, user: user

    guru_applications_tab   = Page::SuperAdmin::GuruApplicationsTab.new
    guru_application_view   = Page::SuperAdmin::GuruApplicationView.new(1)

    sign_in(super_admin)
    guru_applications_tab.visit
    guru_applications_tab.show
    expect(guru_application_view).to have_content 'Kitchen Design, Kids & Youth'
    guru_application_view.go_back
    expect(guru_applications_tab).to have_css 'table'
  end

  scenario 'and rejects application' do
    super_admin             = create :super_admin

    user                    = build :user, signup_way: 'guru'
    user_profile            = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Johnson'
    user.profile = user_profile
    user.save

    second_user             = build :user, signup_way: 'guru'
    second_user_profile     = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Smith'
    second_user.profile = second_user_profile
    second_user.save

    guru_application        = create :guru_application, user: user
    second_guru_application = create :guru_application, user: second_user, review_started_at: Time.zone.now - 10.minutes

    guru_application_view   = Page::SuperAdmin::GuruApplicationView.new(1)

    sign_in(super_admin)
    guru_application_view.visit
    guru_application_view.start_review
    expect(guru_application_view).to have_started_review_notice
    expect(guru_application_view).to have_being_reviewed_status
    guru_application_view.reject
    expect(guru_application_view).to have_rejected_application_notice
    expect(guru_application_view).to have_rejected_status
  end

  scenario 'and accepts application' do
    super_admin             = create :super_admin

    user                    = build :user, signup_way: 'guru'
    user_profile            = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Johnson'
    user.profile = user_profile
    user.save

    guru_application        = create :guru_application, user: user

    guru_application_view   = Page::SuperAdmin::GuruApplicationView.new(1)

    sign_in(super_admin)
    guru_application_view.visit
    guru_application_view.start_review

    expect(guru_application_view).to have_started_review_notice
    expect(guru_application_view).to have_being_reviewed_status

    guru_application_view.accept

    expect(guru_application_view).to have_accepted_application_notice
    expect(guru_application_view).to have_accepted_status
  end

  scenario 'and adds note to the application' do
    super_admin             = create :super_admin

    user                    = build :user, signup_way: 'guru'
    user_profile            = build :user_profile, category_list: ['kids', 'kitchen_design'], last_name: 'Johnson'
    user.profile = user_profile
    user.save

    guru_application        = create :guru_application, user: user

    guru_application_view   = Page::SuperAdmin::GuruApplicationView.new(1)

    sign_in(super_admin)
    guru_application_view.visit
    guru_application_view.fill_in({super_admin_note: 'Super admin new note'})
    guru_application_view.save_note

    expect(guru_application.reload.super_admin_note).to eq('Super admin new note')
  end
end
