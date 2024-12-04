class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def index
    comments = @article.comments.order(created_at: :desc)
    # render json: comments
  end

  def new
    @comment = @article.comments.build
  end

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to article_comments_path, notice: 'コメントを追加'
    else
      flash.now[:error] = '更新できませんでした'
      render :new
    end
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end