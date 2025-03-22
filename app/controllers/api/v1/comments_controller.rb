class Api::V1::CommentsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_article

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
    # @comment.save!
    # render json: @comment.as_json(
    #   include: {
    #     user: {
    #       only: :username,
    #       methods: :avatar_url
    #     }
    #   }
    #   )
    begin
      if @comment.save! # ここで何らかのエラーが発生していそう
        render json: @comment.as_json(
        include: {
          user: {
          only: :username,
          methods: :avatar_url
          }
        }
        )
      else
        flash.now[:error] = '保存に失敗しました'
        render :new
      end
    rescue => e # beginの中でエラーが発生した場合はこちらの処理が実行される
      Rails.logger.error "Unexpected error in comment creation: #{e.message}"
      Rails.logger.error "#{e.backtrace.join("\n")}"
      redirect_to root_path, alert: '保存中にエラーが発生しました'
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