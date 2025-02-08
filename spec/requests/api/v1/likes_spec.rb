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

      it 'いいねステータス(false)を返す' do
        get api_like_path(article_id: article.id)
        body = JSON.parse(response.body)
        expect(body['hasLiked']).to eq(false)
      end

      it 'いいねステータス(true)を返す' do
        article.likes.create!(user: user)
        get api_like_path(article_id: article.id)
        body = JSON.parse(response.body)
        expect(body['hasLiked']).to eq(true)
      end
    end

    context 'ログインしていない場合' do
      it '401ステータスが返ってくる' do
        get api_like_path(article_id: article.id)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/articles/:article_id/like' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'いいねできる' do
        post api_like_path(article_id: article.id)
        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
        expect(body['likesCount']).to eq(1)
        expect(body['lastLikeUsername']).to eq(user.username)
      end
    end

    context 'ログインしていない場合' do
      it '401ステータスが返ってくる' do
        post api_like_path(article_id: article.id)
        expect(response).to have_http_status(401)
      end
    end
  end

end
