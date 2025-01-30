# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  after_create :check_mentions

  private

  def check_mentions
    mentioned_users = self.content.scan(/@(\w+)/).flatten.uniq
    mentioned_users.each do |username|
      user = User.find_by(username: username)
      if user
        send_email(user, self.user, self)
      end
    end
  end

  def send_email(recipient, sender, comment)
    # CommentsMailer.mention_notification(recipient, sender, comment).deliver_later
    # testの時はdeliver_nowを使う
    CommentsMailer.mention_notification(recipient, sender, comment).deliver_now
  end
end
