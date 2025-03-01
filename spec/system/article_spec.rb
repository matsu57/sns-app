require 'rails_helper'

RSpec.describe 'Article', type: :system do
  let!(:user) { create(:user) }
  let!(:articles) { create_list(:article, 3, user: user) }
  let!(:delete_article) { create(:article, user: user, content: 'delete article test') }

  it '記事一覧が表示される' do
    visit root_path
    articles.each do |article|
      expect(page).to have_css('.article_body_content', text: article.content)
    end
  end

  it '記事の詳細が表示される' do
    visit root_path
    article = articles.first
    find(".article_body a[href='#{article_path(article)}']").click
    expect(page).to have_css('.article_body_content', text: article.content)
  end

  context 'ログインしている場合' do
    before do
      login_as(user) #capybaraを使用しているテストでloginの不具合が発生するのでsign_in userを使わず自作のHelperを使用
      visit root_path
    end

    it '記事の投稿ができる', js: true do
      find(".header_left a[href='#{new_article_path}']").click
      expect(page).to have_css('.user_userName', text: user.username)
      fill_in 'article[content]', with: 'post article test'
      # ファイルパスを準備
      file_path = Rails.root.join('app/assets/images/test2.png')

      # ファイルをアップロード(フォームを非表示にしているためmake_visible: trueが必要)
      attach_file('imageUpload', file_path, make_visible: true)

      # ファイル選択後にchangeイベントを強制的に発火(ファイル選択ダイアログを直接操作できないために必要)
      execute_script("document.getElementById('imageUpload').dispatchEvent(new Event('change', { bubbles: true }))")

      # 画像のプレビューが表示されるまで待機
      expect(page).to have_css('.form_select ul li', text: 'test2.png', wait: 10)

      click_on 'Post'
      # root_pathに遷移するのを確認
      expect(page).to have_current_path(root_path, wait: 10)
      expect(page).to have_content('post article test')
      expect(page).to have_css("img[src*='test2.png']")
    end

    it '記事の投稿をキャンセルできる', js: true do
      find(".header_left a[href='#{new_article_path}']").click
      expect(page).to have_css('.user_userName', text: user.username)
      fill_in 'article[content]', with: 'cancel article test'
      # ファイルパスを準備
      file_path = Rails.root.join('app/assets/images/test2.png')

      # ファイルをアップロード(フォームを非表示にしているためmake_visible: trueが必要)
      attach_file('imageUpload', file_path, make_visible: true)

      # ファイル選択後にchangeイベントを強制的に発火(ファイル選択ダイアログを直接操作できないために必要)
      execute_script("document.getElementById('imageUpload').dispatchEvent(new Event('change', { bubbles: true }))")

      # 画像のプレビューが表示されるまで待機
      expect(page).to have_css('.form_select ul li', text: 'test2.png', wait: 10)

      click_on 'Canc'
      # root_pathに遷移するのを確認
      expect(page).to have_current_path(root_path, wait: 10)
      expect(page).not_to have_content('cancel article test')
      expect(page).not_to have_css("img[src*='test2.png']")
      expect(Article.count).to eq(4)
    end

    it '文章のみの投稿はできない', js: true do
      find(".header_left a[href='#{new_article_path}']").click
      expect(page).to have_css('.user_userName', text: user.username)
      fill_in 'article[content]', with: 'This is a test article'
      click_on 'Post'
      expect(page).to have_content("Images can't be blank", wait: 10)
      expect(page).to have_current_path(new_article_path)
      expect(Article.count).to eq(4) #もとからあった4つの記事から増えない
    end

    it '画像のみの投稿はできない', js: true do
      find(".header_left a[href='#{new_article_path}']").click
      expect(page).to have_css('.user_userName', text: user.username)
      # ファイルパスを準備
      file_path = Rails.root.join('app/assets/images/test2.png')

      # ファイルをアップロード(フォームを非表示にしているためmake_visible: trueが必要)
      attach_file('imageUpload', file_path, make_visible: true)

      # ファイル選択後にchangeイベントを強制的に発火(ファイル選択ダイアログを直接操作できないために必要)
      execute_script("document.getElementById('imageUpload').dispatchEvent(new Event('change', { bubbles: true }))")

      click_on 'Post'
      expect(page).to have_content("Content can't be blank", wait: 10)
      expect(page).to have_current_path(new_article_path)
      expect(Article.count).to eq(4) #もとからあった4つの記事から増えない
    end

    it '自分で作成した記事を削除できる', js: true do
      expect(page).to have_content('delete article test')
      page.accept_confirm do
        find(".article_body_delete a[href='#{article_path(delete_article)}']").click
      end
      expect(page).not_to have_content('delete article test')
      expect(Article.count).to eq(3)
    end
  end
end
