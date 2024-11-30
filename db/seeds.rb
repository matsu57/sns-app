# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# john = User.create!(email: 'john@sample.com', password: 'password', username: 'john')
# emily = User.create!(email: 'emily@sample.com', password: 'password', username: 'emily')

# 既存のユーザーを取得
john = User.find_by(username: 'john') # ここで適切な条件でユーザーを検索
emily = User.find_by(username: 'emily') # ここで適切な条件でユーザーを検索

# ユーザーが存在する場合のみ記事を作成
if john
  4.times do
    article = john.articles.create!(
      content: Faker::Lorem.sentence(word_count: 5)
    )
    
    # 画像を記事に添付
    article.images.attach(
      io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
      filename: 'login-bg.png'
    )
  end
else
  puts "User 'John' not found."
end

# if emily
#   2.times do
#     article = emily.articles.create!(
#       content: Faker::Lorem.sentence(word_count: 5)
#     )
    
#     # 画像を記事に添付
#     article.images.attach(
#       io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
#       filename: 'login-bg.png'
#     )
#   end
# else
#   puts "User 'emily' not found."
# end