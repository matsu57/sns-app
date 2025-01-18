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
      flash[:notice] = 'プロフィール更新完了'
    else
      flash[:error] = 'プロフィール更新に失敗しました'
      # エラーメッセージも含める
      flash[:errors] = @profile.errors.full_messages.join(', ')
    end
    redirect_to profile_path
  end

  private
  def profile_params
    params.require(:profile).permit(:avatar)
  end
end