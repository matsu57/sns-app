class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def index
    comments = @article.comments.order(created_at: :desc)
    # render json: comments
  end

  def create
    @comment = @article.comments.build(comment_params)
    if @comment.save
      redirect_to @article, notice: 'コメントが投稿されました'
    else
      render 'index'
    end
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.permit(:comment_content)
  end

end