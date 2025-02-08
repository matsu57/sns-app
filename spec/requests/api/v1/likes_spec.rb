require 'rails_helper'

RSpec.describe 'Api::Likes', type: :request do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }

  describe 'GET /api/articles/:article_id/like' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200ステータスが返ってくる' do
        get api_like_path(article_id: article.id)
        expect(response).to have_http_status(200)
      end

      it 'いいねステータスを返す' do
        get api_like_path(article_id: article.id)
        expect(JSON.parse(response.body)).to include('hasLiked' => false)
      end
    end

    # context '未認証ユーザーの場合' do
    #   it '401ステータスが返ってくる' do
    #     get api_article_like_path(article_id: article.id)
    #     expect(response).to have_http_status(401)
    #   end
    # end
  end
end
