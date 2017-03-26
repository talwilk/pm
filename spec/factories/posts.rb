FactoryGirl.define do
  factory :post, class: 'Blog::Post' do
    title Faker::Lorem.sentence
    content Faker::Lorem.paragraph
  end
end
