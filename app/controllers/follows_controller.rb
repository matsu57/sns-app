class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @user= User.find(params[:account_id])
    @tab = params[:tab] || 'Followers'

    if @tab == 'Following'
      @users = @user.followings.all
    else
      @users = @user.followers.all
    end
  end

  def show
    follow_status = current_user.has_followed?(@user)
    render json: { hasFollowed: follow_status, followersCount: @user.reload.followers.count }
  end

  def create
    current_user.follow!(params[:account_id])
    @user= User.find(params[:account_id])
    # redirect_to account_path(params[:account_id])
    render json: { status: 'ok', followersCount: @user.reload.followers.count }
  end

  private
  def set_user
    @user= User.find(params[:account_id])
  end
end