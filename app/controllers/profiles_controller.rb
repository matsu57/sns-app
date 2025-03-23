class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @profile = current_user.profile
  end

  # def update
  #   @profile = current_user.prepare_profile
  #   @profile.assign_attributes(profile_params)
  #   if @profile.save
  #     flash[:notice] = 'プロフィール更新完了'
  #   else
  #     flash[:error] = 'プロフィール更新に失敗しました'
  #     エラーメッセージも含める
  #     flash[:errors] = @profile.errors.full_messages.join(', ')
  #   end
  #   redirect_to profile_path
  # end

  def update
    @profile = current_user.prepare_profile
    begin
      if @profile.update(profile_params)
        flash[:notice] = 'プロフィール更新完了'
        redirect_to profile_path
      else
        flash.now[:error] = 'プロフィール更新に失敗しました'
        flash.now[:errors] = @profile.errors.full_messages.join(', ')
        render :edit
      end
    rescue => e
      Rails.logger.error "Unexpected error in profile update: #{e.message}"
      Rails.logger.error "Error class: #{e.class}"
      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.error "Parameters: #{params.inspect}"
      redirect_to profile_path, alert: '予期せぬエラーが発生しました'
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:avatar)
  end
end