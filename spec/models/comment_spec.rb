require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user, username: 'send_user') }

  context '内容が入力されている場合' do
    let!(:article) { create(:article) }
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

  context 'メンション付きのコメントが入力されている場合' do
    let(:user) { create(:user) }
    let!(:user2) { create(:user, username: 'recipient_user', email: 'recipient@example.com') }
    let!(:article) { create(:article, user: user2) }

    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'コメントは保存され、メールが送られる' do
      comment_content = "@recipient_user #{Faker::Lorem.sentence(word_count: 5)}"

      expect {
        @comment = article.comments.create!({
          content: comment_content,
          user: user
        })
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(@comment).to be_valid
    end
  end

  context '間違ったメンション付きのコメントが入力されている場合' do
    let(:user) { create(:user) }
    let!(:user2) { create(:user, username: 'recipient_user', email: 'recipient@example.com') }
    let!(:article) { create(:article, user: user2) }

    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'コメントは保存されるが、メールが送信されない' do
      comment_content = "@wrong_username #{Faker::Lorem.sentence(word_count: 5)}"

      expect {
        @comment = article.comments.create!({
          content: comment_content,
          user: user
        })
      }.to change { ActionMailer::Base.deliveries.count }.by(0)
      expect(@comment).to be_valid
    end
  end

  context '内容が入力されていない場合' do
    let!(:article) { create(:article) }
    let!(:comment) do
      article.comments.build({
        content: '',
        user: user
      })
    end

    before do
      comment.save
    end
    it 'コメントを保存できない' do
      expect(comment.save).to be false
      expect(Comment.count).to eq(0)
      expect(comment.errors.messages[:content][0]).to eq("can't be blank")
    end
  end
end
