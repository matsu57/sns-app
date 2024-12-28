class TimelinesController < ApplicationController
  before_action :authenticate_user!

  def show
    user_ids = current_user.followings.pluck(:id)
    @articles = Article.where(user_id: user_ids)

    @like_articles = @articles
      .where('articles.created_at >= ?', 24.hours.ago) #{articleの中で24時間以内に作成}
      .joins(:likes) #{likesテーブルと結合する}
      .group(:id) #{記事IDでグループ化。各記事ごとのいいね数を集計できる}
      .order('articles.created_at DESC, COUNT(likes.id) DESC') #{新着順でいいねの数が多い順に並べ替え}
      .limit(5) #{上位5件の記事のみを選択}
  end
end