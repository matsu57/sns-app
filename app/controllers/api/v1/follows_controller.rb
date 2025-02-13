class Api::V1::FollowsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    follow_status = current_user.has_followed?(@user)
    render json: { hasFollowed: follow_status, followersCount: @user.reload.followers.count }
  end

  def create
    current_user.follow!(params[:account_id])
    @user= User.find(params[:account_id])
    render json: { status: 'ok', followersCount: @user.reload.followers.count }
  end

  private
  def set_user
    @user= User.find(params[:account_id])
  end
end