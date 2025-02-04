require 'rails_helper'

RSpec.describe Article, type: :model do
  let!(:user) { create(:user) }

  context '内容と画像が入力されている場合' do
    let!(:article) do
      article = user.articles.create({
        content: Faker::Lorem.sentence(word_count: 5)
      })
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
        filename: 'default-avatar.png',
        content_type: 'image/png'
      )
      article
    end

    it '記事を保存できる' do
      expect(article).to be_valid
    end
  end

  context '内容が入力され選択画像が4枚以下の場合' do
    let!(:article) do
      article = user.articles.create({
        content: Faker::Lorem.sentence(word_count: 5)
      })
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
        filename: 'default-avatar.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
        filename: 'login-bg.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/test1.png')),
        filename: 'test1.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/test2.png')),
        filename: 'test2.png',
        content_type: 'image/png'
      )
      article
    end

    it '記事を保存できる' do
      expect(article).to be_valid
    end
  end

  context '内容が入力されていない場合' do
    let!(:article) do
      article = user.articles.build({
        content: ''
      })
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
        filename: 'default-avatar.png',
        content_type: 'image/png'
      )
      article
    end

    before do
      article.save
    end

    it '記事を保存できない' do
      expect(article.errors.messages[:content][0]).to eq("can't be blank")
    end
  end

  context '画像が選択されていない場合' do
    let!(:article) do
      article = user.articles.build({
        content: Faker::Lorem.sentence(word_count: 5)
      })
    end

    before do
      article.save
    end

    it '記事を保存できない' do
      expect(article.errors.messages[:images][0]).to eq("can't be blank")
    end
  end

  context '内容は入力されているが、画像が5枚以上の場合' do
    let!(:article) do
      article = user.articles.build({
        content: Faker::Lorem.sentence(word_count: 5)
      })
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
        filename: 'default-avatar.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/default-avatar.png')),
        filename: 'default-avatar.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/login-bg.png')),
        filename: 'login-bg.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/test1.png')),
        filename: 'test1.png',
        content_type: 'image/png'
      )
      article.images.attach(
        io: File.open(Rails.root.join('app/assets/images/test2.png')),
        filename: 'test2.png',
        content_type: 'image/png'
      )
      article
    end

    before do
      article.save
    end

  it '記事を保存できない' do
    expect(article.errors.messages[:base][0]).to eq("Please select no more than 4 images")
    end
  end
end
