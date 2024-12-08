class CommentsMailer < ApplicationMailer
  def mention_notification(recipient, sender, articleId)
    @recipient = recipient
    @sender = sender
    @articleId = article
    mail to: recipient.email, subject: '【お知らせ】コメントがありました'
  end
end