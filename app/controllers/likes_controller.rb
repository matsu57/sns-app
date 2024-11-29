class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def create
    @article.likes.create!(user_id: current_user.id)
    redirect_to root_path

  end

  def destroy
    like = @article.likes.find_by(user_id: current_user.id)
    like.destroy!
    redirect_to root_path

  end

  private
  def set_article
    @article = Article.find(params[:article_id])
  end
end