class AccountsController < ApplicationController
  def show
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to profile_path
    else
      render :show
    end
  end
end