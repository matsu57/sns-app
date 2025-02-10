require 'rails_helper'

RSpec.describe 'Articles', type: :request do
  let!(:user) { create(:user) }
  let!(:articles) { create_list(:article, 3, user: user) }

  describe 'GET /articles' do
    it '200ステータスが返ってくる' do
      get articles_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /articles' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end
      it '記事が保存される' do
        article_params = attributes_for(:article)
        image_file = fixture_file_upload(Rails.root.join('app/assets/images/test1.png'), 'image/png')
        post articles_path, params: { article: article_params.merge(images: [image_file]) }

        expect(response).to have_http_status(302)
        expect(Article.last.content).to eq(article_params[:content])
        expect(Article.last.images).to be_attached
      end

      it '無効なパラメータでは記事が保存されない' do
        invalid_article_params = attributes_for(:article, content: nil)
        expect {
          post articles_path, params: { article: invalid_article_params }
        }.not_to change(Article, :count)

        expect(response).to have_http_status(200) # ステータスコードが200（フォーム再表示）であることを確認
        expect(flash[:error]).to eq '保存に失敗しました'
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        article_params = attributes_for(:article)
        post articles_path({article: article_params})
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /articles/new' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '入力フォームが表示される' do
        get new_article_path
        expect(response).to have_http_status(200)
        expect(response.body).to include('name="article[content]"')
        expect(response.body).to include('name="article[images][]"')
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get new_article_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /articles/:id' do
    context 'ログイン状態に関係なく、articleが存在する場合' do
      let!(:article) { create(:article) }

      it "記事の詳細が表示される" do
        get article_path(article)
        expect(response).to have_http_status(200)
        expect(response.body).to include(article.content)
        expect(response.body).to include('test1.png')
        expect(response.body).to include(article.user.username)
      end
    end
  end

  describe 'DELETE /articles/:id' do
    let!(:article) { create(:article, user: user) }
    let!(:other_user) { create(:user) }
    let!(:other_article) { create(:article, user: other_user) }

    context 'ログインしていて、自分が作成した記事の場合' do
      before do
        sign_in user
      end

      it '記事が削除され、root_pathにリダイレクトされる' do
        expect {
          delete article_path(article)
        }.to change(Article, :count).by(-1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq '削除できました'
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get new_article_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
