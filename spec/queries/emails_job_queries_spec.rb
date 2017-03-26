require 'rails_helper'

describe "Email's job queries" do
  let!(:user) { create :confirmed_user, email: 'regular@user.email', country_iso: 'PL', password: 'password', last_sign_in_at: Time.zone.now - 10.days, role: 'regular'}
  let!(:user_2) { create :confirmed_user, email: 'regular@user2.email', country_iso: 'PL', password: 'password', last_sign_in_at: Time.zone.now - 9.days, role: 'regular', confirmation_token: 'testtoken2'}
  let!(:user_3) { create :confirmed_user, email: 'regular@user3.email', country_iso: 'PL', password: 'password', last_sign_in_at: Time.zone.now - 11.days, role: 'regular', confirmation_token: 'testtoken3', first_dilemma_solved: true}
  let!(:user_4) { create :confirmed_user, email: 'regular@user4.email', country_iso: 'PL', password: 'password', last_sign_in_at: Time.zone.now - 10.days, role: 'regular', confirmation_token: 'testtoken4'}
  let!(:dilemma) {create :dilemma, user: user_4, description: 'Abcd', category_list:['Architecture'], ends_at: Time.zone.now - 5.minutes}
  let!(:dilemma_2) {create :dilemma, user: user_2, description: 'Abcd2',category_list:['Kids']}
  let!(:dilemma_3) {create :dilemma, user: user_3, description: 'Abcd3',category_list:['Kids'], ends_at: Time.zone.now - 5.minutes}
  let!(:dilemma_4) {create :dilemma, user: user_3, description: 'Abcd4',category_list:['Architecture'], ends_at: Time.zone.now - 2.days}
  let!(:dilemma_5) {create :dilemma, user: user_4, description: 'Abcd5',category_list:['Architecture']}
  let!(:dilemma_6) {create :dilemma, user: user_3, description: 'Abcd6',category_list:['Architecture'], ends_at: Time.zone.now - 5.minutes}
  let!(:user_5) { create :confirmed_user, country_iso: 'PL', email: 'regular@user5.email', password: 'password', last_sign_in_at: Time.zone.now - 10.days, role: 'regular', confirmation_token: 'testtoken5'}
  let!(:advice) { create :dilemma_advice, dilemma: dilemma, user: user_5, content: 'This is a content' }

  it "returns results" do
    guru = create(:user, email: 'existing@guru.email', country_iso: 'PL', role: 'guru', signup_way: 'guru')
    guru.profile.update_attributes(experience: '1_5_years', category_list: ['Architecture'])

    # returns users for welcome emails
    expect(DailyWelcomeEmailQuery.new.results).to match_array([user])

    # returns users for first dilemma solved
    expect(FirstDilemmaSolvedEmailQuery.new.results).to match_array([user_4])

    # returns dilemmas for advice
    expect(DilemmasForAdviceEmailQuery.new(guru, ['Architecture']).results).to match_array([dilemma_5])
  end
end
