class Api::V1::FollowsController < Api::ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    follow_status = current_user.has_followed?(@user)
    render json: { hasFollowed: follow_status, followersCount: @user.reload.followers.count }
  end

  def create
    if current_user.has_followed?(@user)
      render json: { error: 'Already following this user', followersCount: @user.followers.count }
    else
      current_user.follow!(@user)
      render json: { status: 'ok', followersCount: @user.followers.count }
    end
  end

  private
  def set_user
    @user= User.find(params[:account_id])
  end
end