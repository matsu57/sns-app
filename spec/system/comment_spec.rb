require 'rails_helper'

RSpec.describe 'Comment', type: :system do
  let!(:user) { create(:user) }
  let!(:article) { create(:article) }
  let!(:comments) { create_list(:comment, 3, article: article) }

  context 'ログインしている場合' do
    before do
      login_as(user) #capybaraを使用しているテストでloginの不具合が発生するのでsign_in userを使わず自作のHelperを使用
      visit root_path
    end

    it 'コメント一覧が表示される' do
      find(".article_body_icon_comment a[href='#{article_comments_path(article)}']").click
      expect(page).to have_css('.header_center p', text: 'Comment')
      expect(page).to have_selector('.comment_content', count: 3)
    end

    it '記事にコメント出来る', js: true do
      find(".article_body_icon_comment a[href='#{article_comments_path(article)}']").click
      expect(page).to have_css('.header_center p', text: 'Comment')
      fill_in 'comment_content', with: 'post comment test'
      find(".comment_btn").click
      expect(page).to have_css('.comment_userName', text: user.username)
      expect(page).to have_content('post comment test')
      expect(page).to have_selector('.comment_content', count: 4)
    end

    it 'メンション付きコメントを投稿するとメールが送信される', js: true do
      mentioned_user = create(:user, username: 'mentioned_user')
      comment_content = '@mentioned_user, this is a test comment'

      find(".article_body_icon_comment a[href='#{article_comments_path(article)}']").click
      expect(page).to have_css('.header_center p', text: 'Comment')

      expect {
        fill_in 'comment_content', with: comment_content
        find(".comment_btn").click
        sleep 1
      }.to change { ActionMailer::Base.deliveries.count }.by(1)

      expect(page).to have_css('.comment_userName', text: user.username)
      expect(page).to have_content(comment_content)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(mentioned_user.email)

      mail_body = mail.body.to_s
      expect(mail_body).to include('コメントを確認するには以下のリンクをクリックしてください：')
      expect(mail_body).to include(mentioned_user.username)
      expect(mail_body).to include(user.username)
      expect(mail_body).to include(comment_content)

      expect(page).to have_selector('.comment_content', count: 4)
    end
  end
end