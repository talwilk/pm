FactoryGirl.define do
  factory :dilemma do
    category_list 'Architecture'
    title {'New dilemma'}
    description {'Dilemma dilemma dilemma dilemma dilemma'}
    ends_at  Time.zone.now + 72.hours
    favorite_advice_ends_at  Time.zone.now + 120.hours
    user
    after(:build) do |dilemma|
      dilemma.media << FactoryGirl.create(:file, mediable: dilemma)
    end
    factory :dilemma_with_advices do
      after(:build) do |dilemma|
        dilemma.advices << FactoryGirl.create(:dilemma_advice, dilemma: dilemma)
      end
    end
  end
end
