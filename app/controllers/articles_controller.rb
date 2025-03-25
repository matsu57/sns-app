class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    @articles = Article.all.order(created_at: :desc)
  end

  def new
    @article = current_user.articles.build
  end

  def show
    @article = Article.find(params[:id])
  end

    def create
    @article = current_user.articles.build(article_params)
    begin
      if @article.save # ここで何らかのエラーが発生していそう
        redirect_to root_path, notice: '保存しました'
      else
        flash.now[:error] = '保存に失敗しました'
        render :new
      end
    rescue => e # beginの中でエラーが発生した場合はこちらの処理が実行される
      Rails.logger.error "Unexpected error in article creation: #{e.message}"
      Rails.logger.error "#{e.backtrace.join("\n")}"
      redirect_to root_path, alert: '保存中にエラーが発生しました'
    end
  end

  def destroy
      article = current_user.articles.find(params[:id])
    begin
      article.destroy! # ここで何らかのエラーが発生していそう
      redirect_to root_path, notice: '削除できました'
    rescue => e # beginの中でエラーが発生した場合はこちらの処理が実行される
      Rails.logger.error "Unexpected error in article deletion: #{e.message}"
      Rails.logger.error "#{e.backtrace.join("\n")}"
      redirect_to root_path, alert: '削除中にエラーが発生しました'
    end
  end

  private
  def article_params
    params.require(:article).permit(:content, images: [])
  end
end