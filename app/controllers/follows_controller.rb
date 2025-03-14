class FollowsController < ApplicationController
  before_action :set_user

  def index
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