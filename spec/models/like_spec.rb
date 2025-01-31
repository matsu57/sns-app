require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { create(:user) }
  let!(:article) { create(:article) }

  context 'いいねした場合' do
    let!(:like) do
      article.likes.create(user: user)
    end

    it 'いいねの状態が保存される' do
      expect(like).to be_valid
    end
  end

  context '同じ記事に同じユーザーがいいねした場合' do
    let!(:like1) do
      article.likes.create(user: user)
    end

    it 'いいねが重複して作成されない' do
      like2 = build(:like, article: article, user: user)
      expect(like2).not_to be_valid
      expect(like2.errors[:user_id]).to include("has already been taken")
    end
  end
end
