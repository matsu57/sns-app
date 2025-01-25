require 'rails_helper'

RSpec.describe Article, type: :model do
  let!(:user) do
    User.create!({
      email: 'test@examlpe.com',
      password: 'password',
      username: 'test1'
    })
  end

  context 'タイトルと内容が入力されている場合' do
    let(:article) do
      article = user.articles.build(
        content: Faker::Lorem.sentence(word_count: 5)
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
        filename: 'login-bg.png'
      )
      article
    end

    it '記事を保存できる' do
      expect(article).to be_valid
    end
  end

  context '内容が入力されていない場合' do
    let(:article) do
      article = user.articles.create(
        content: ''
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
        filename: 'login-bg.png'
      )
      article
    end

    it '記事を保存できない' do
      expect(article.errors.messages[:content][0]).to eq("can't be blank")
    end
  end
end
