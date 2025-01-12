# frozen_string_literal: true

module UserDecorator
  def avatar_image
    if profile&.avatar&.attached?
      # &.attached?で画像がアップロードされているか調べる
      profile.avatar
    else
      'default-avatar.png'
    end
  end

  def avatar_url
    if profile&.avatar&.attached?
      Rails.application.routes.url_helpers.rails_blob_path(profile.avatar, only_path: true)
    else
      ActionController::Base.helpers.asset_path('default-avatar.png')
    end
  end

end
