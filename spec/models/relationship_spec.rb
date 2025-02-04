require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  context '正しい情報が与えられた場合' do
    let!(:relationship) { create(:relationship, follower:user1, following: user2) }

    it 'フォロー関係が作られる' do
      expect(relationship).to be_valid
      expect(user1.has_followed?(user2)).to be true
    end
  end
end
