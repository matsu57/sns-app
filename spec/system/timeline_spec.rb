require 'rails_helper'

RSpec.describe 'Timeline', type: :system do
  let!(:user) { create(:user) }
  let!(:followed_user1) { create(:user) }
  let!(:followed_user2) { create(:user) }
  let!(:unfollowed_user) { create(:user) }

  context 'ログインしていて、followしている人が24時間以内に投稿し、いいねがある場合' do
    before do
      login_as(user) #capybaraを使用しているテストでloginの不具合が発生するのでsign_in userを使わず自作のHelperを使用
      visit root_path
      user.follow!(followed_user1)
      user.follow!(followed_user2)

      # テストデータ作成
      @article1 = create(:article, user: followed_user1, created_at: 25.hours.ago)
      @article2 = create(:article, user: followed_user2, created_at: 23.hours.ago)
      @article3 = create(:article, user: followed_user1, created_at: 22.hours.ago)
      @article4 = create(:article, user: followed_user2, created_at: 23.hours.ago)
      @article5 = create(:article, user: unfollowed_user, created_at: 21.hours.ago)

      # いいねデータ作成
      create(:like, article: @article2, user: followed_user1, created_at: 22.hours.ago)
      create(:like, article: @article2, user: user, created_at: 21.hours.ago)
      create(:like, article: @article2, user: unfollowed_user, created_at: 20.hours.ago)
      create(:like, article: @article3, user: user, created_at: 15.hours.ago)
      create(:like, article: @article3, user: followed_user2, created_at: 14.hours.ago)
      create(:like, article: @article4, user: followed_user1, created_at: 10.hours.ago)
    end

    it '正しい数の記事が表示される' do # テスト名を具体的に変更
      click_on 'Timeline'
      # @article1（25時間前）と@article7（フォロー外）は非表示
      expect(page).to have_selector('.article', count: 3)
      expect(page).to have_selector('.article_body_likeCount p', text: "#{unfollowed_user.username} and 2 others liked your post")
      expect(page).to have_selector('.article_body_likeCount p', text: "#{followed_user2.username} and 1 other liked your post")
      expect(page).to have_selector('.article_body_likeCount p', text: "#{followed_user1.username} liked your post")
    end
  end

  context 'ログインしていて、followしている人はいるが24時間以内の投稿がない' do
    before do
      login_as(user) #capybaraを使用しているテストでloginの不具合が発生するのでsign_in userを使わず自作のHelperを使用
      visit root_path
      user.follow!(followed_user1)
      user.follow!(followed_user2)

      # テストデータ作成
      @article1 = create(:article, user: followed_user1, created_at: 25.hours.ago)
      @article2 = create(:article, user: followed_user2, created_at: 26.hours.ago)

      # いいねデータ作成
      create(:like, article: @article1, user: followed_user1, created_at: 20.hours.ago)
      create(:like, article: @article1, user: followed_user2, created_at: 16.hours.ago)
      create(:like, article: @article2, user: unfollowed_user, created_at: 22.hours.ago)
    end

    it '記事が表示されない' do # テスト名を具体的に変更
      click_on 'Timeline'
      expect(page).not_to have_selector('.article')
    end
  end

  context 'ログインしていて、followしている人がいない場合' do
    before do
      login_as(user) #capybaraを使用しているテストでloginの不具合が発生するのでsign_in userを使わず自作のHelperを使用
      visit root_path

      # テストデータ作成
      @article1 = create(:article, user: followed_user1, created_at: 25.hours.ago)
      @article2 = create(:article, user: followed_user2, created_at: 23.hours.ago)
      @article3 = create(:article, user: unfollowed_user, created_at: 18.hours.ago)

      # いいねデータ作成
      create(:like, article: @article1, user: followed_user1, created_at: 20.hours.ago)
      create(:like, article: @article1, user: followed_user2, created_at: 16.hours.ago)
      create(:like, article: @article2, user: unfollowed_user, created_at: 22.hours.ago)
      create(:like, article: @article3, user: user, created_at: 15.hours.ago)
    end

    it '記事が表示されない' do # テスト名を具体的に変更
      click_on 'Timeline'
      expect(page).not_to have_selector('.article')
    end
  end
end
