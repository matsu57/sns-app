require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  context '正しい情報が与えられた場合' do
    let!(:relationship) { create(:relationship, follower: user1, following: user2) }

    it 'フォロー関係が作られる' do
      expect(relationship).to be_valid
      expect(user1.has_followed?(user2)).to be true
    end
  end

  context 'フォローしている人をフォローしようとした場合' do
    let!(:relationship) { create(:relationship, follower: user1, following: user2) }
    let!(:new_relationship) { build(:relationship, follower: user1, following: user2) }

    it 'フォロー関係を再作成しない' do
      expect(new_relationship.save).to be false
      expect(new_relationship.errors.full_messages).to include("Follower has already been taken")
    end
  end

  context '自分をフォローしようとした場合' do
    let!(:relationship) { build(:relationship, follower: user1, following: user1) }

    it 'フォロー関係を再作成しない' do
      expect(relationship.save).to be false
      expect(relationship.errors.full_messages).to include("Follower cannot follow yourself")
    end
  end
end
