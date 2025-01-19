class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @profile = current_user.profile
  end

  def edit
    @profile = current_user.prepare_profile
  end

  def update
    @profile = current_user.prepare_profile
    @profile.assign_attributes(profile_params)
    if @profile.save
      redirect_to profile_path, notice: 'プロフィール更新完了'
    else
      flash.now[:error] = 'プロフィール更新に失敗しました'
      render :edit
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:avatar)
  end
end