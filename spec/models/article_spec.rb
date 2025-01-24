require 'rails_helper'

RSpec.describe Article, type: :model do
  it '内容と画像が入力されていれば、記事を保存できる' do
    user = User.create!({
      email: 'test@examlpe.com',
      password: 'password',
      username: 'test1'
    })
    article = user.articles.build({
      content: Faker::Lorem.sentence(word_count: 8),
      # imagesにActiveStorage::Blobオブジェクトを配列で設定
      images: [ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/login-bg.png')), filename: 'login-bg.png', content_type: 'image/png')] 
    })

    expect(article).to be_valid
  end
end
