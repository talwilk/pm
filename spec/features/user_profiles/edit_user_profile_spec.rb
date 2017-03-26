require 'rails_helper'

feature 'User edits profile' do
  let!(:user) { create :user, email: 'regular2@user.email', password: 'password'}
  let!(:guru_user) { create :user, email: 'guru@user.email', password: 'password', role: 'guru'}
  let(:edit_page) { Page::UserProfile::EditUserProfile.new }
  let(:show_page) { Page::UserProfile::ShowUserProfile.new }
  let(:sign_in_page) {Page::User::Authentication::SignIn.new }
  let(:home_page) {Page::User::Home.new }

  scenario 'with valid fields' do
    sign_in(user)
    edit_page.visit
    edit_page.fill_in(first_name: 'Alex',
                      last_name: 'Murdoch',
                      facebook_link: 'https://www.facebook.com/faku',
                      google_plus_link: 'https://plus.google.com/10033317946569222/posts',
                      twitter_link: 'https://twitter.com/AwAsds',
                      pinterest_link: 'https://pl.pinterest.com/afku/',
                      instagram_link: 'https://www.instagram.com/asdasdasd2/',
    )
    edit_page.edit_avatar
    edit_page.change_avatar
    edit_page.submit
    user.profile.reload
    expect(user.profile.first_name).to eq('Alex')
    expect(user.profile.last_name).to eq('Murdoch')
  end

  scenario 'even without first and last name' do
    sign_in(user)
    edit_page.visit
    edit_page.fill_in(first_name: '',
                      last_name: '',
                      facebook_link: 'https://www.facebook.com/faku',
                      google_plus_link: 'https://plus.google.com/10033317946569222/posts',
                      twitter_link: 'https://twitter.com/AwAsds',
                      pinterest_link: 'https://pl.pinterest.com/afku/',
                      instagram_link: 'https://www.instagram.com/asdasdasd2/',
    )
    edit_page.edit_avatar
    edit_page.change_avatar
    edit_page.submit
    user.profile.reload
    expect(user.profile.first_name).to eq('')
    expect(user.profile.last_name).to eq('')
  end

  scenario 'to remove avatar' do
    uploader = AvatarUploader.new(user.profile, :avatar)
    File.open("#{Rails.root}/spec/fixtures/test-image/box.png") do |f|
      uploader.store!(f)
    end
    user.profile.save
    sign_in(user)
    edit_page.visit
    edit_page.edit_avatar
    edit_page.remove_avatar
    user.reload
    expect(user.profile.avatar_url).to eq('default/default-avatar.png')
  end

  scenario 'not logged in' do
    edit_page.visit
    expect(sign_in_page).to have_need_to_login_notice
  end

  scenario 'with valid fields, locked phone and image(guru)' do
    sign_in(guru_user)
    edit_page.visit
    edit_page.fill_in(first_name: 'Alex',
                      last_name: 'Murdoch',
                      website_link: 'https://www.google.com',
                      facebook_link: 'https://www.facebook.com/faku',
                      google_plus_link: 'https://plus.google.com/10033317946569222/posts',
                      twitter_link: 'https://twitter.com/AwAsds',
                      pinterest_link: 'https://pl.pinterest.com/afku/',
                      instagram_link: 'https://www.instagram.com/asdasdasd2/',
                      mobile_number: '+48 444 777 999',
                      company: 'Panda Fabrica',
                      mantra: 'Love life',
                      address: 'Artyleryjska 123'
    )
    edit_page.show_email
    edit_page.show_number
    edit_page.edit_avatar
    edit_page.change_avatar
    edit_page.submit
    guru_user.profile.reload
    expect(guru_user.profile.first_name).to eq('Alex')
    expect(guru_user.profile.last_name).to eq('Murdoch')
    expect(guru_user.profile.mantra).to eq('Love life')
    expect(guru_user.profile.company).to eq('Panda Fabrica')
  end

  scenario 'without first name(guru)' do
    sign_in(guru_user)
    edit_page.visit
    edit_page.fill_in(first_name: '',
                      last_name: 'Murdoch',
                      website_link: 'https://www.google.com',
                      facebook_link: 'https://www.facebook.com',
                      google_plus_link: 'https://plus.google.com',
                      twitter_link: 'https://www.twitter.com',
                      pinterest_link: 'https://www.pinterest.com',
                      instagram_link: 'https://www.instagram.com',
                      mobile_number: '123 123 123',
                      company: 'Panda Fabrica',
                      mantra: 'Love life',
                      address: 'Artyleryjska 123'
    )
    edit_page.show_email
    edit_page.show_number
    edit_page.edit_avatar
    edit_page.change_avatar
    edit_page.submit
    expect(edit_page).to have_blank_field_notice
  end

  scenario 'without last name(guru)' do
    sign_in(guru_user)
    edit_page.visit
    edit_page.fill_in(first_name: 'Alex',
                      last_name: '',
                      website_link: 'https://www.google.com',
                      facebook_link: 'https://www.facebook.com',
                      google_plus_link: 'https://plus.google.com',
                      twitter_link: 'https://www.twitter.com',
                      pinterest_link: 'https://www.pinterest.com',
                      instagram_link: 'https://www.instagram.com',
                      mobile_number: '123 123 123',
                      company: 'Panda Fabrica',
                      mantra: 'Love life',
                      address: 'Artyleryjska 123'
    )
    edit_page.show_email
    edit_page.show_number
    edit_page.edit_avatar
    edit_page.change_avatar
    edit_page.submit
    expect(edit_page).to have_blank_field_notice
  end

  scenario 'with invalid links' do
    sign_in(user)
    edit_page.visit
    edit_page.fill_in(first_name: 'Alex',
                      last_name: 'Murdoch',
                      facebook_link: 'https://www.faceboeeeok.com/faku',
                      google_plus_link: 'https://plus.googsadle.com/10033317946569222/posts',
                      twitter_link: 'https://twittedasdr.com/AwAsds',
                      pinterest_link: 'https://pl.pasdsinterest.com/afku/',
                      instagram_link: 'https://www.instadasdagram.com/asdasdasd2/',
    )
    edit_page.submit
    expect(edit_page).to have_invalid_facebook_link_error
    expect(edit_page).to have_invalid_twitter_link_error
    expect(edit_page).to have_invalid_instagram_link_error
    expect(edit_page).to have_invalid_pinterest_link_error
    expect(edit_page).to have_invalid_google_plus_link_error
  end
end
