class CommentsMailer < ApplicationMailer
  def mention_notification(recipient, sender, comment)
    @recipient = recipient
    @sender = sender
    @comment = comment.content
    @article_id = comment.article_id
    mail to: recipient.email, subject: '【お知らせ】メンション付きコメントがありました'
  end
end