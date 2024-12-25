class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def show
    like_status = current_user.has_liked?(@article)
    render json: { hasLiked: like_status }
  end

  def create
    @article.likes.create!(user_id: current_user.id)
    render json: { status: 'ok', likesCount: @article.reload.likes.count }
  end

  def destroy
    like = @article.likes.find_by(user_id: current_user.id)
    like.destroy!
    render json: { status: 'ok', likesCount: @article.reload.likes.count }
  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end
end