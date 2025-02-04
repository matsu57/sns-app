FactoryBot.define do
  factory :article do
    user { association :user } # 関連するユーザーを自動的に作成
    content { Faker::Lorem.sentence(word_count: 5) }

    # after(:build)を使うことで、オブジェクトがメモリ上に作成された後に画像を添付します。
    after(:build) do |article|
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/test1.png')),
        filename: 'test1.png',
        content_type: 'image/png'
      )
    end
  end
end
