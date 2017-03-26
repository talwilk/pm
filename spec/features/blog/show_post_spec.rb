require 'rails_helper'

feature 'User visits index page', skip: true do
  let!(:admin) { create :super_admin, email: 'regular@user.email', password: 'password' }
  let!(:post_1) { create :post, title: 'Post1', content: 'Blablabla', super_admin: admin }
  let!(:user) { create :user }

  let(:show_page) { Page::Post::ShowPost.new }

  scenario 'as logged user' do
    sign_in(user)
    show_page.visit(post_1.id)
    expect(show_page).to have_content 'Post1'
    expect(show_page).to have_content 'Blablabla'
  end

  scenario 'as not logged user' do
    show_page.visit(post_1.id)
    expect(show_page).to have_content 'Post1'
    expect(show_page).to have_content 'Blablabla'
  end

  scenario 'as not admin' do
    sign_in(admin)
    show_page.visit(post_1.id)
    expect(show_page).to have_content 'Post1'
    expect(show_page).to have_content 'Blablabla'
  end
end
