class CommentsMailer < ApplicationMailer
  def mention_notification(recipient, sender, comment)
    @recipient = recipient
    @sender = sender
    mail to: recipient.email, subject: '【お知らせ】コメントがありました'
  end
end