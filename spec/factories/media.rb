FactoryGirl.define do
  factory :medium do
    association :mediable, factory: [:dilemma, :dilemma_advice]
    factory :youtube do
      youtube_url {'https://www.youtube.com/watch?v=FmZpo4NWvxQ'}
    end

    factory :file do
      file {Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test-image/box.png')))}
    end

    factory :image do
      image_url {'http://www.queness.com/resources/images/png/apple_ex.png'}
    end
  end
end
