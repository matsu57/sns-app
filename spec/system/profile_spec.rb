require 'rails_helper'

RSpec.describe 'Profile', type: :system do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }
  let!(:other_user) { create(:user) }
  let!(:other_article) { create(:article, user: other_user) }
  let!(:follower_user) { create(:user) }
  let!(:following_user) { create(:user) }

  context 'ログインしている場合' do
    before do
      login_as(user) #capybaraを使用しているテストでloginの不具合が発生するのでsign_in userを使わず自作のHelperを使用
      user.prepare_profile.save! #profileの準備
      visit root_path
      user.follow!(following_user)
      follower_user.follow!(user)
    end

    it '自分のプロフィールが表示される' do
      find(".article[data-article-id='#{article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: user.username)
      expect(page).to have_css('.profile_body_basicInfo_followers', text: '1')
      expect(page).to have_css('.profile_body_basicInfo_following', text: '1')
    end

    it 'profile画像を更新できる', js: true do
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
      expect(page).to have_css('#avatar-preview[src*="test2.png"]', wait: 5)
    end

    it '他のユーザのアカウントページが表示される' do
      find(".article[data-article-id='#{other_article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: other_user.username)
    end

    it '他のユーザをfollowする', js: true do
      visit account_path(other_user)
      expect(page).to have_css('.header_center', text: other_user.username)

      click_on 'Follow'
      expect(page).not_to have_button('Follow')
      expect(page).to have_button('Unfollow')
      expect(page).to have_css('.profile_body_basicInfo_followers', text: '1', wait: 5)
      # ページをリロード
      visit current_path
      expect(page).to have_css("a[href='#{account_follows_path(other_user, tab: 'Followers')}']")
    end

    it '他のユーザのプロフィールは更新できない' do
      find(".article[data-article-id='#{other_article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: other_user.username)
      expect(page).not_to have_css('#avatar-input')
    end

    it 'followerを確認する' do
      find(".article[data-article-id='#{article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: user.username)
      expect(page).to have_css('.profile_body_basicInfo_followers', text: '1', wait: 5)
      find("a[href='#{account_follows_path(user, tab: 'Followers')}']").click
      expect(page).to have_content(follower_user.username)
    end

    it 'followingを確認する' do
      find(".article[data-article-id='#{article.id}'] .article_header").click
      expect(page).to have_css('.header_center', text: user.username)
      expect(page).to have_css('.profile_body_basicInfo_followers', text: '1', wait: 5)
      find("a[href='#{account_follows_path(user, tab: 'Following')}']").click
      expect(page).to have_content(following_user.username)
    end

    it 'followしているユーザをunfollowする', js: true do
      visit account_path(following_user)
      expect(page).to have_css('.header_center', text: following_user.username)

      click_on 'Unfollow'
      expect(page).not_to have_button('Unfollow')
      expect(page).to have_button('Follow')
      expect(page).to have_css('.profile_body_basicInfo_followers', text: '0', wait: 5)
      # ページをリロード
      visit current_path
      expect(page).not_to have_css("a[href='#{account_follows_path(following_user, tab: 'Followers')}']")
    end
  end
end
