require 'rails_helper'

RSpec.describe 'Profile', type: :system do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }
  let!(:other_user) { create(:user) }
  let!(:other_article) { create(:article, user: other_user) }

  context 'ログインしている場合' do
    before do
      sign_in user
      user.prepare_profile.save! #profileの準備
    end

    it '自分のプロフィールが表示される' do
      visit root_path
      find(".article[data-article-id='#{article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: user.username)
    end

    it 'profile画像を更新できる', js: true do
      visit root_path
      find(".article[data-article-id='#{article.id}'] .article_header").click
      # ページ読み込みの完了を待つ
      expect(page).to have_css('#avatar-preview')

      # ファイルパスを準備
      file_path = Rails.root.join('app/assets/images/test2.png')

      # ファイルをアップロード(フォームを非表示にしているためmake_visible: trueが必要)
      attach_file('avatar-input', file_path, make_visible: true)

      # ファイル選択後にchangeイベントを強制的に発火(ファイル選択ダイアログを直接操作できないために必要)
      execute_script("document.getElementById('avatar-input').dispatchEvent(new Event('change', { bubbles: true }))")

      # プロフィールを再読み込みして画像が更新されたことを確認
      user.profile.reload
      expect(user.profile.avatar).to be_attached
      expect(page).to have_css('#avatar-preview[src*="test2.png"]', wait: 10)
    end

    it '他のユーザのアカウントページが表示される' do
      visit root_path
      find(".article[data-article-id='#{other_article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: other_user.username)
    end

    it '他のユーザのプロフィールは更新できない' do
      visit root_path
      find(".article[data-article-id='#{other_article.id}'] .article_header").click
      expect(page).not_to have_css('#avatar-input')
    end
  end
end
