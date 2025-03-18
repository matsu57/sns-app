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

    before do
      user.save
    end

    it 'ユーザー情報を保存できない' do
      expect(user.errors.messages[:email][0]).to include("can't be blank")
    end
  end

  context 'usernameが入力されていない場合' do
    let!(:user) { build(:user, username: '') }

    before do
      user.save
    end

    it 'ユーザー情報を保存できない' do
      expect(user.errors.messages[:username][0]).to include("can't be blank")
    end
  end

  context 'passwordが入力されていない場合' do
    let!(:user) { build(:user, password: '') }

    before do
      user.save
    end

    it 'ユーザー情報を保存できない' do
      expect(user.errors.messages[:password][0]).to include("can't be blank")
    end
  end

  context '同じemailが入力された場合' do
    let!(:user1) { create(:user, email: 'test@example.com') }
    let!(:user2) { build(:user, email: 'test@example.com') }

    before do
      user2.save
    end

    it 'ユーザー情報を保存できない' do
      expect(user2.errors.messages[:email][0]).to include("has already been taken")
    end
  end

  context '同じusernameが入力された場合' do
    let!(:user1) { create(:user, username: 'test_username') }
    let!(:user2) { build(:user, username: 'test_username') }

    before do
      user2.save
    end

    it 'ユーザー情報を保存できない' do
      expect(user2.errors.messages[:username][0]).to include("has already been taken")
    end
  end

  context '正しいemail形式でないもの入力された場合' do
    let!(:user) { build(:user, email: 'test') }

    before do
      user.save
    end

    it 'ユーザー情報を保存できない' do
      expect(user.errors.messages[:email][0]).to include("is invalid")
    end
  end

  describe 'prepare_profile' do
    subject { user.prepare_profile }

    context 'プロフィールが存在しない場合' do
      let(:user) { create(:user) }

      it '新しいプロフィールをbuildするが保存はしない' do
        expect(user.profile).to be_nil
        expect { subject }.not_to change(Profile, :count) # buildなのでDBレコード数は変わらない
        expect(subject).to be_a(Profile) # Profileオブジェクトが返る
        expect(subject.persisted?).to be false # 保存されていない状態を確認
        expect(user.profile).to eq(subject) # ユーザーに関連付けられている
      end
    end

    context 'プロフィールが既に存在する場合' do
      let!(:profile) { create(:profile) }
      let(:user) { profile.user } # プロフィールからユーザーを取得

      it '既存のプロフィールを返す' do
        expect { subject }.not_to change(Profile, :count)
        expect(subject).to eq(profile)
        expect(subject.persisted?).to be true
      end
    end
  end

  describe 'has_liked?' do
    subject { user.has_liked?(article) }
    let!(:user) { create(:user) }
    let!(:article) { create(:article) }

    context 'いいねが存在する場合' do
      before do
        article.likes.create(user: user)
      end

      it 'trueを返す' do
        expect(subject).to be true
      end
    end

    context 'いいねが存在しない場合' do
      it 'falseを返す' do
        expect(subject).to be false
      end
    end

    context '異なるユーザーがいいねをしている場合' do
      let!(:another_user) { create(:user) }

      before do
        article.likes.create(user: another_user)
      end

      it 'falseを返す' do
        expect(subject).to be false
      end
    end

    context 'articleがnilの場合' do
      let(:article) { nil }

      it 'falseを返す' do
        expect(subject).to be false
      end
    end
  end

  describe 'follow!' do
    subject { user1.follow!(user2) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    context '正しい情報が与えられた場合' do
      it 'フォロー関係が正常に作成される' do
      expect { subject }.to change(Relationship, :count).by(1) # relationshipレコードが一件増える
      expect(Relationship.last.follower).to eq(user1) # 作成されたレコードのfollowerがuser1である
      expect(Relationship.last.following).to eq(user2) # 作成されたレコードのfollowingがuser2である
      end
    end

    context '既にフォローしている場合' do
      before do
        user1.follow!(user2)
      end

      it '例外が発生する' do
        expect {
          subject
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context '自分自身をフォローしようとした場合' do
      it '例外が発生する' do
        expect {
          user1.follow!(user1)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end


  describe 'unfollow!' do
    subject { user1.unfollow!(user2) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:another_user) { create(:user) }

    context 'すでにフォロー関係がある場合' do
      before do
        user1.follow!(user2)
      end

      it 'フォロー関係が削除される' do
        expect { subject }.to change(Relationship, :count).by(-1)
        expect(user1.has_followed?(user2)).to be false
      end
    end

    context 'フォロー関係がない場合' do
      it '例外が発生する' do
      expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # describe 'has_followed?' do

  # end
end
