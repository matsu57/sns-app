require 'rails_helper'

RSpec.describe "Timelines", type: :request do
  let!(:user) { create(:user) }
  let!(:followed_user1) { create(:user) }
  let!(:followed_user2) { create(:user) }
  let!(:unfollowed_user) { create(:user) }

  describe 'GET /timeline' do
    context 'ログインしていて、followしている人が24時間以内に投稿し、いいねがある場合' do
      before do
        sign_in user
        # フォロー関係の作成
        user.follow!(followed_user1)
        user.follow!(followed_user2)

        # フォローしているユーザーの記事を作成
        @article1 = create(:article, user: followed_user1, created_at: 25.hours.ago)
        @article2 = create(:article, user: followed_user2, created_at: 23.hours.ago)
        @article3 = create(:article, user: followed_user1, created_at: 22.hours.ago)
        @article4 = create(:article, user: followed_user2, created_at: 21.hours.ago)
        @article5 = create(:article, user: followed_user1, created_at: 20.hours.ago)
        @article6 = create(:article, user: followed_user2, created_at: 19.hours.ago)

        # フォローしていないユーザーの記事を作成
        @article7 = create(:article, user: unfollowed_user, created_at: 18.hours.ago)

        # いいねを追加
        create(:like, article: @article2, user: followed_user1, created_at: 20.hours.ago)
        create(:like, article: @article3, user: followed_user2, created_at: 16.hours.ago)
        create(:like, article: @article3, user: unfollowed_user, created_at: 22.hours.ago)
        create(:like, article: @article3, user: user, created_at: 15.hours.ago)
        create(:like, article: @article4, user: followed_user1, created_at: 19.hours.ago)
        create(:like, article: @article5, user: followed_user2, created_at: 21.hours.ago)
        create(:like, article: @article6, user: followed_user1, created_at: 17.hours.ago)
        create(:like, article: @article6, user: unfollowed_user, created_at: 18.hours.ago)
      end

      it '正しい記事が取得されること' do
        get timeline_path
        like_articles = controller.instance_variable_get('@like_articles')
        expect(like_articles).not_to include(@article1)  # 24時間以上前の記事
        expect(like_articles.all? { |article| article.likes.where('created_at >= ?', 24.hours.ago).exists? }).to be true
      end

      it 'いいねが多い記事が新着順に並んでいること' do
        get timeline_path
        like_articles = controller.instance_variable_get('@like_articles')
        actual_order = like_articles.map { |a| [a.id, a.likes.count] }
        # puts "実際の並び順: #{actual_order}"
        expected_order = [@article3, @article6, @article5, @article4, @article2].map { |a| [a.id, a.likes.count] }
        # puts "予測される並び順: #{expected_order}"
        expect(actual_order).to eq(expected_order)
      end

      it '結果が5件に制限されていること' do
        get timeline_path
        like_articles = controller.instance_variable_get('@like_articles')
        expect(like_articles.size).to eq(5)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get timeline_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
