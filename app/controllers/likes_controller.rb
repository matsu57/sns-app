class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    article = Article.find(params[:article_id])
    article.likes.create!(user_id: current_user)
    redirect_to root_path
  end
end