FactoryBot.define do
  factory :article do
    content { Faker::Lorem.sentence(word_count: 5) }
    after(:build) do |article|
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
        filename: 'login-bg.png',
        content_type: 'image/png'
      )
    end
  end
end