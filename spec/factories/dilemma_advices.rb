FactoryGirl.define do
  factory :dilemma_advice do
    content Faker::Lorem.sentence
    dilemma
    user
  end
end

