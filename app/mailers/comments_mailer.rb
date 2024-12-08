class CommentsMailer < ApplicationMailer
  def mention_notification(recipient, sender, article_id, comment_content)
    @recipient = recipient
    @sender = sender
    @article_id = article_id
    @comment_content = comment_content
    mail to: recipient.email, subject: '【お知らせ】コメントがありました'
  end
end