FactoryGirl.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { 'password' }
    association :profile, factory: :user_profile
    first_dilemma_added false
    country_iso 'PL'

    factory :unconfirmed_user do
      confirmation_token 'testtoken'
      confirmed_at nil
      confirmation_sent_at { Time.now }
    end

    factory :confirmed_user do
      confirmation_token 'testtoken'
      confirmed_at { Time.now + 2.hours}
      confirmation_sent_at { Time.now }
    end

    factory :guru_user do
      role 'guru'
    end
  end
end
