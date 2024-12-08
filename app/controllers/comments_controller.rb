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
    @comment.save!
    render json: @comment.as_json(
      include: {
        user: {
          only: :username,
          methods: :avatar_url
        }
      }
      )
    send_email(@article.user, @comment.user)
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def send_email(recipient, sender)
    CommentsMailer.mention_notification(recipient, sender).deliver_later
  end

end