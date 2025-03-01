class Api::V1::UnfollowsController < Api::ApplicationController
  before_action :authenticate_user!

  def create
    @user= User.find(params[:account_id])
    if current_user.has_followed?(@user)
      current_user.unfollow!(params[:account_id])
      render json: { status: 'ok', followersCount: @user.reload.followers.count }
    else
      render json: { error: 'You are not yet following user', followersCount: @user.followers.count }
    end
  end
end