class Api::V1::CommentsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!
    render json: @comment.as_json(
      include: {
        user: {
          only: :username,
          methods: :avatar_url
        }
      }
      )
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end