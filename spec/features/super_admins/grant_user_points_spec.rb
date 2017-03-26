require 'rails_helper'

feature 'Super admin visits users tab and' do
  scenario 'successfully grants user points' do
    super_admin = create(:super_admin)
    user = create(:user)
    user.profile.update_attributes(first_name: "John", last_name: "Smith")

    super_admin_users_tab = Page::SuperAdmin::Users::Index.new
    super_admin_user_show_view = Page::SuperAdmin::Users::Edit.new(user)
    super_admin_grant_user_points_view = Page::SuperAdmin::GrantUserPointsView.new(1)

    sign_in(super_admin)
    super_admin_users_tab.visit
    click_link 'John Smith'
    super_admin_user_show_view.grant_user_points
    super_admin_grant_user_points_view.fill_in(points_amount: 10, super_admin_granted_points_description: 'Just because.')
    super_admin_grant_user_points_view.submit
    expect(super_admin_user_show_view).to have_successful_grant_points_message
    expect(UserPointsLog).to exist(points_amount: 10, super_admin_granted_points_description: 'Just because.', activity: 'super_admin_grant_points')

    # tries to grant points without filling point amount
    super_admin_user_show_view.grant_user_points
    super_admin_grant_user_points_view.fill_in(points_amount: '', super_admin_granted_points_description: 'Just because.')
    super_admin_grant_user_points_view.submit
    expect(super_admin_grant_user_points_view).to have_blank_field_alert

    # tries to grant points without description
    super_admin_grant_user_points_view.fill_in(points_amount: 10, super_admin_granted_points_description: '')
    super_admin_grant_user_points_view.submit
    expect(super_admin_grant_user_points_view).to have_blank_field_alert
  end
end
