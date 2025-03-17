FactoryBot.define do
  factory :profile do
    user { association :user } # 関連するユーザーを自動的に作成

    # after(:build)を使うことで、オブジェクトがメモリ上に作成された後に画像を添付します。
    after(:build) do |profile|
      profile.avatar.attach(
        io: File.open(Rails.root.join('app/assets/images/test2.png')),
        filename: 'test2.png',
        content_type: 'image/png'
      )
    end
  end
end
