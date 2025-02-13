class Api::V1::UnfollowsController < Api::ApplicationController
  before_action :authenticate_user!

  def create
    current_user.unfollow!(params[:account_id])
    @user= User.find(params[:account_id])
    render json: { status: 'ok', followersCount: @user.reload.followers.count }
  end
end