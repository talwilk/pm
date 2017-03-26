require 'rails_helper'

feature 'User visits index page', skip: true do
  let!(:admin) { create :super_admin, email: 'regular@user.email', password: 'password' }
  let!(:post_1) { create :post, title: 'Post1', super_admin: admin }
  let!(:post_2) { create :post, title: 'Post2', super_admin: admin }
  let!(:user) { create :user }

  let(:index_page) { Page::Post::IndexPost.new }

  scenario 'as logged user' do
    sign_in(user)
    index_page.visit
    expect(index_page).to have_content 'Post1'
    expect(index_page).to have_content 'Post2'
  end

  scenario 'as not logged user' do
    index_page.visit
    expect(index_page).to have_content 'Post1'
    expect(index_page).to have_content 'Post2'
  end
end
