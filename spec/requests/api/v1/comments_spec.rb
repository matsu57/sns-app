require 'rails_helper'

RSpec.describe "Api::V1::Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }

  describe "POST /api/articles/:article_id/comments" do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'コメントを追加できる' do
        comment_params = attributes_for(:comment)
        expect {
          post api_comments_path(article_id: article.id), params: { comment: comment_params }
        }.to change(Comment, :count).by(1)

        body = JSON.parse(response.body)
        expect(body['content']).to eq(comment_params[:content])
        expect(body['user_id']).to eq user.id
        expect(body['article_id']).to eq article.id
      end
    end

    context 'ログインしていない場合' do
      it '401ステータスが返ってくる' do
        post api_comments_path(article_id: article.id)
        expect(response).to have_http_status(401) #{アクセス権が無い、または認証に失敗}
      end
    end
  end
end
