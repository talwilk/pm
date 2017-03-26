FactoryGirl.define do
  factory :super_admin do
    email { Faker::Internet.safe_email }
    full_name { Faker::Name.name }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
