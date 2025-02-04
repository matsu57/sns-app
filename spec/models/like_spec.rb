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
    let!(:like2) do
      article.likes.build(user: user)
    end
    before do
      like2.save
    end

    it 'いいねが重複して作成されない' do
      expect(like2.errors.messages[:user_id][0]).to eq("has already been taken")
    end
  end
end
