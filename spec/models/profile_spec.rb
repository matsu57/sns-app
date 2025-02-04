require 'rails_helper'

RSpec.describe Profile, type: :model do
  let!(:user) { create(:user) }

  context 'profileでavatar画像を設定したとき' do
    let!(:profile) do
      profile = user.build_profile
      profile.avatar.attach(
        io: File.open(Rails.root.join('app/assets/images/test1.png')),
        filename: 'test1.png',
        content_type: 'image/png'
      )
      profile
    end

    before do
      profile.save
    end

    it 'avatarが保存される' do
      expect(profile.avatar).to be_attached
      expect(profile).to be_valid
    end
  end
end
