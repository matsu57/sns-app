require 'rails_helper'

RSpec.describe User, type: :model do
  context '正しい情報が与えられた場合' do
    let!(:user) { build(:user) }

    it 'ユーザー情報が保存される' do
      expect(user).to be_valid
    end
  end

  context 'emailが入力されていない場合' do
    let!(:user) { build(:user, email: '') }

    it 'ユーザー情報を保存できない' do
      expect(user).not_to be_valid
      expect(user.errors.messages[:email][0]).to include("can't be blank")
    end
  end

  context 'usernameが入力されていない場合' do
    let!(:user) { build(:user, username: '') }

    it 'ユーザー情報を保存できない' do
      expect(user).not_to be_valid
      expect(user.errors.messages[:username][0]).to include("can't be blank")
    end
  end

  context '同じemailが入力された場合' do
    let!(:user1) { create(:user, email: 'test@example.com') }
    let!(:user2) { build(:user, email: 'test@example.com') }

    it 'ユーザー情報を保存できない' do
      expect(user2).not_to be_valid
      expect(user2.errors.messages[:email][0]).to include("has already been taken")
    end
  end

  context '同じusernameが入力された場合' do
    let!(:user1) { create(:user, username: 'test_username') }
    let!(:user2) { build(:user, username: 'test_username') }

    it 'ユーザー情報を保存できない' do
      expect(user2).not_to be_valid
      expect(user2.errors.messages[:username][0]).to include("has already been taken")
    end
  end
end
