FactoryBot.define do
  factory :comment do
    user { association :user } # 関連するユーザーを自動的に作成
    content { Faker::Lorem.sentence(word_count: 10) }
  end
end