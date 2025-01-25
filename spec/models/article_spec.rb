require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'タイトルと内容が入力されている場合' do
    let!(:user) do
      User.create!({
        email: 'test@examlpe.com',
        password: 'password',
        username: 'test1'
      })
    end

    let!(:article) do
      user.articles.build({
        content: Faker::Lorem.sentence(word_count: 8),
        # imagesにActiveStorage::Blobオブジェクトを配列で設定
        images: [ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/login-bg.png')), filename: 'login-bg.png', content_type: 'image/png')] 
      })
    end
    # before do
    #   user = User.create!({
    #     email: 'test@examlpe.com',
    #     password: 'password',
    #     username: 'test1'
    #   })
    #   @article = user.articles.build({
    #     content: Faker::Lorem.sentence(word_count: 8),
    #     # imagesにActiveStorage::Blobオブジェクトを配列で設定
    #     images: [ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join('app/assets/images/login-bg.png')), filename: 'login-bg.png', content_type: 'image/png')] 
    #   })
    # end

    it '記事を保存できる' do
      expect(@article).to be_valid
    end
  end
end
