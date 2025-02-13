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

  private
  def set_user
    @user= User.find(params[:account_id])
  end
end