class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def index
    comments = @article.comments.order(created_at: :desc)
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end

end