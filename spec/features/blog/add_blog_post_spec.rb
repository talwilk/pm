require 'rails_helper'

feature 'Superadmin adds post', skip: true, js: true do
  let!(:admin) { create :super_admin, email: 'regular2@user.email', password: 'password'}

  let(:new_page) { Page::Post::AddPost.new }
  let(:index_page) { Page::Post::AdminIndexPost.new }

  scenario 'with valid data' do
    sign_in(admin)
    new_page.visit
    new_page.fill_in(
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph
    )
    new_page.submit
    expect(index_page).to have_successful_created_post_notice
  end

  scenario 'with valid data and photo' do
    sign_in(admin)
    new_page.visit
    new_page.fill_in(
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph
    )
    new_page.attach_image
    new_page.submit
    expect(index_page).to have_successful_created_post_notice
  end

  scenario 'empty content' do
    sign_in(admin)
    new_page.visit
    new_page.fill_in(
      title: Faker::Lorem.sentence
    )
    new_page.submit
    expect(new_page).to have_blank_alert
  end

  scenario 'with empty title' do
    sign_in(admin)
    new_page.visit
    new_page.fill_in(
      content: Faker::Lorem.paragraph
    )
    new_page.submit
    expect(new_page).to have_blank_alert
  end
end
