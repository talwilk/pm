require 'rails_helper'

feature 'User likes advice' do
  let!(:user) { create :confirmed_user, email: 'regular@user.email', password: 'password' }
  let!(:user_not_owner) { create :confirmed_user, id: 123, email: 'not_regular@user.email', password: 'password', confirmation_token: 'testtoken2' }
  let!(:user_2) { create :confirmed_user, email: 'not_regular2@user.email', password: 'password', confirmation_token: 'testtoken22' }
  let!(:user_profile) { create :user_profile, user: user }
  let!(:dilemma) { create :dilemma, user: user, category_list:['Architecture'] }
  let!(:advice) { create :dilemma_advice, dilemma: dilemma, user: user_not_owner, content: 'This is a content' }
  let(:show_page) { Page::Dilemma::ShowDilemma.new }

  scenario 'user likes and unlikes advice' do
    sign_in(user)
    show_page.visit(dilemma.id)

    show_page.like
    show_page.has_unlike
    expect(DilemmaAdvice).to exist(cached_votes_up: 1, content: 'This is a content')

    show_page.unlike
    show_page.has_like
    expect(DilemmaAdvice).to exist(cached_votes_up: 0, content: 'This is a content')
  end

  scenario 'user likes and unlikes advice liked by another user', :js do
    advice.liked_by user_2
    advice.save
    sign_in(user)
    show_page.visit(dilemma.id)
    show_page.like
    show_page.has_unlike
    expect(DilemmaAdvice).to exist(cached_votes_up: 2, content: 'This is a content')
    show_page.unlike
    show_page.has_like
    expect(DilemmaAdvice).to exist(cached_votes_up: 1, content: 'This is a content')
  end

  scenario '- own advice', :js do
    sign_in(user)
    show_page.visit(dilemma.id)
    show_page.has_no_unlike
    show_page.has_no_like
  end

  scenario 'can not unlike others user like' do
    advice.liked_by user_2
    advice.save
    sign_in(user)
    show_page.visit(dilemma.id)
    show_page.has_no_unlike
  end
end
