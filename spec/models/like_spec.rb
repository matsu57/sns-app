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
end
