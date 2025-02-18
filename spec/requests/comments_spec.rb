require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:user) { create(:user) }
  let!(:article) { create(:article, user: user) }
  let!(:comments) { create_list(:comment, 3, article: article)}

  describe 'GET /articles/:article_id/comments' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200ステータスが返ってくる' do
        get article_comments_path(article_id: article.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get article_comments_path(article_id: article.id)
        expect(response).to have_http_status(302) #{Locationで示されたURLへ移動した}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
