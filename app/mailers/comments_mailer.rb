class CommentsMailer < ApplicationMailer
  def mention_notification(recipient, sender, comment)
    @recipient = recipient
    @sender = sender
    @comment = comment.content
    @article = comment.article
    -# テスト用のhost設定
    @host = 'example.com'  # または適切なホスト名
    mail to: recipient.email, subject: '【お知らせ】メンション付きコメントがありました'
  end
end