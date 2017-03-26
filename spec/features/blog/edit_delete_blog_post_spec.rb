require 'rails_helper'

feature 'Superadmin edits post', skip: true do
  let!(:admin) { create :super_admin, email: 'regular@user.email', password: 'password'}
  let!(:post) { create :post, super_admin: admin}

  let(:edit_page) { Page::Post::EditPost.new }
  let(:index_page) { Page::Post::AdminIndexPost.new }

  scenario 'with valid data' do
    sign_in(admin)
    edit_page.visit(post.id)
    edit_page.fill_in(
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph
    )
    edit_page.submit
    expect(index_page).to have_successful_updated_post_notice
  end

  scenario 'with valid data and photo' do
    sign_in(admin)
    edit_page.visit(post.id)
    edit_page.fill_in(
      title: Faker::Lorem.sentence,
      content: Faker::Lorem.paragraph
    )
    edit_page.attach_image
    edit_page.submit
    expect(index_page).to have_successful_updated_post_notice
  end

  scenario 'empty content', js: true do
    sign_in(admin)
    edit_page.visit(post.id)
    edit_page.fill_in(
      title: '',
      content: ''
    )
    edit_page.submit
    expect(edit_page).to have_blank_alert
  end

  scenario 'with empty title', js:true do
    sign_in(admin)
    edit_page.visit(post.id)
    edit_page.fill_in(
      title: '',
      content: Faker::Lorem.paragraph
    )
    edit_page.submit
    expect(edit_page).to have_blank_alert
  end

  scenario 'and delete' do
    sign_in(admin)
    index_page.visit
    index_page.choose_delete_link
    expect(index_page).to have_successful_delete_post_notice
    expect(Blog::Post).not_to exist(id: post.id)
  end
end

