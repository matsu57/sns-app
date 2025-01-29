require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let!(:article) { create(:article) }

  context '内容が入力されている場合' do
    let!(:comment) do
      article.comments.create({
        content: Faker::Lorem.sentence(word_count: 5),
        user: user
      })
    end

    it 'コメントを保存できる' do
      expect(comment).to be_valid
    end
  end
end
