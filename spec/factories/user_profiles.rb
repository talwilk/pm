FactoryGirl.define do
  factory :user_profile do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    facebook_link {'http://facebook.com'}
    instagram_link {'http://instagram.com'}
    google_plus_link {'http://plus.google.com'}
    pinterest_link {'http://pinterest.com'}
    twitter_link {'http://twitter.com'}
    website_link {'http://example.com'}
    avatar {Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test-image/box.png')))}
  end
end
