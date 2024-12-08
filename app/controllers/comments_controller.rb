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
    check_mentions(@comment)
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def check_mentions(comment)
    mentioned_users = comment.content.scan(/@(\w+)/).flatten.uniq
    mentioned_users.each do |username|
      user = User.find_by(username: username)
      if user
        send_email(user, comment.user, comment.article.id, comment.content)
      end
    end
  end

  def send_email(recipient, sender, article_id, comment)
    CommentsMailer.mention_notification(recipient, sender, article_id, comment).deliver_now
  end

end