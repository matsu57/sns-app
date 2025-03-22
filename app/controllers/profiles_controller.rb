class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @profile = current_user.profile
  end

  def update
    @profile = current_user.prepare_profile
    @profile.assign_attributes(profile_params)
    # if @profile.save
    #   flash[:notice] = 'プロフィール更新完了'
    # else
    #   flash[:error] = 'プロフィール更新に失敗しました'
    #   # エラーメッセージも含める
    #   flash[:errors] = @profile.errors.full_messages.join(', ')
    # end
    # redirect_to profile_path
    begin
      if @profile.save # ここで何らかのエラーが発生していそう
        redirect_to profile_path, notice: '保存しました'
      else
        flash[:error] = 'プロフィール更新に失敗しました'
        # エラーメッセージも含める
        flash[:errors] = @profile.errors.full_messages.join(', ')
      end
    rescue => e # beginの中でエラーが発生した場合はこちらの処理が実行される
      Rails.logger.error "Unexpected error in profile creation: #{e.message}"
      Rails.logger.error "#{e.backtrace.join("\n")}"
      redirect_to profile_path, alert: '保存中にエラーが発生しました'
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:avatar)
  end
end