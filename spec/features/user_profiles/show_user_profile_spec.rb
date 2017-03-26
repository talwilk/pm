require 'rails_helper'

feature 'User visits' do
  scenario "user views his profile" do
    user = create :user, email: 'regular@user.email', password: 'password'
    user_not_owner = create :confirmed_user, id: 123, email: 'not_regular2@user.email', password: 'password', confirmation_token: 'testtoken2'
    user_profile = create :user_profile, user: user

    dilemma = create :dilemma, user: user, category_list:['Architecture']
    dilemma_2 = create :dilemma, user: user, category_list:['Architecture']
    dilemma_3 = create :dilemma, user: user, category_list:['Architecture']
    dilemma_4 = create :dilemma, user: user, category_list:['Architecture']
    dilemma_5 = create :dilemma, user: user, category_list:['Architecture']
    dilemma_6 = create :dilemma, user: user, category_list:['Architecture']
    dilemma_not_owned = create :dilemma, user: user_not_owner, category_list:['Architecture']
    dilemma_not_owned_2 = create :dilemma, user: user_not_owner, category_list:['Architecture']
    dilemma_not_owned_3 = create :dilemma, user: user_not_owner, category_list:['Architecture']
    dilemma_not_owned_4 = create :dilemma, user: user_not_owner, category_list:['Architecture']
    dilemma_not_owned_5 = create :dilemma, user: user_not_owner, category_list:['Architecture']
    advice = create :dilemma_advice, dilemma: dilemma_not_owned, user: user
    advice_2 = create :dilemma_advice, dilemma: dilemma_not_owned, user: user
    advice_3 = create :dilemma_advice, dilemma: dilemma_not_owned_2, user: user
    advice_4 = create :dilemma_advice, dilemma: dilemma_not_owned_3, user: user
    advice_5 = create :dilemma_advice, dilemma: dilemma_not_owned_4, user: user
    advice_6 = create :dilemma_advice, dilemma: dilemma_not_owned_5, user: user
    edit_page = Page::UserProfile::EditUserProfile.new
    show_page = Page::UserProfile::ShowUserProfile.new
    sign_in_page = Page::User::Authentication::SignIn.new

    # Open profile as guest
    show_page.visit(user.id)
    expect(sign_in_page).to have_need_to_login_notice

    sign_in(user)
    show_page.visit(user.id)

    expect(show_page).to have_username
    expect(show_page).to have_counter_class

    show_page.choose_user_advices_dilemmas
    expect(show_page).to have_counter_class
    show_page.load_more_dilemmas
    expect(show_page).to have_counter_class
  end

  scenario "user views guru profile" do
    user = build :user, email: 'regular@user.email', password: 'password'
    user_profile = build :user_profile
    user.profile = user_profile
    user.save

    guru_user = build :user, email: 'guru@user.email', password: 'password', role: 'guru'
    guru_user_profile = build :user_profile, mobile_number: '123123123', company: 'Panda', address: 'Wojskowa', mantra: 'Love life'
    guru_user.profile = guru_user_profile
    guru_user.save

    show_page = Page::UserProfile::ShowUserProfile.new

    sign_in(user)

    show_page.visit(guru_user.id)
    expect(show_page).to_not have_edit_button

    # Guru with locked phone and email
    guru_user.profile.update_columns(show_email: false, show_mobile_number: false)

    show_page.visit(guru_user.id)
    expect(show_page).not_to have_unlocked_phone_field
    expect(show_page).not_to have_unlocked_email_field

    # Guru with unlocked phone and email
    guru_user.profile.update_columns(show_email: true, show_mobile_number: true)

    show_page.visit(guru_user.id)
    expect(show_page).to have_unlocked_phone_field
    expect(show_page).to have_unlocked_email_field
  end

  scenario "guru views his profile" do
    guru_user = create :user, email: 'guru@user.email', password: 'password', role: 'guru'

    show_page = Page::UserProfile::ShowUserProfile.new

    sign_in(guru_user)
    show_page.visit(guru_user.id)
    expect(show_page).to have_unlocked_email_field
  end
end
