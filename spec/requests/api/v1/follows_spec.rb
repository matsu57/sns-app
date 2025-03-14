require 'rails_helper'

RSpec.describe 'Api::V1::Follows', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'GET /api/account/:account_id/follows/:id' do
    context 'ログインしている場合' do
      before do
        sign_in user
        sign_in other_user
      end

      it '200ステータスを返す' do
        get api_follow_path(account_id: user.id, id: other_user.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていて、other_userがuserをfollowしていない場合' do
      before do
        sign_in user
        sign_in other_user
      end

      it 'falseを返す' do
        get api_follow_path(account_id: user.id, id: other_user.id)
        body = JSON.parse(response.body)
        expect(body['hasFollowed']).to eq(false)
      end
    end

    context 'ログインしていて、other_userがuserをfollowしている場合' do
      before do
        sign_in user
        sign_in other_user
        other_user.follow!(user)
      end

      it 'trueを返す' do
        get api_follow_path(account_id: user.id, id: other_user.id)
        body = JSON.parse(response.body)
        expect(body['hasFollowed']).to eq(true)
        expect(body['followersCount']).to eq(1)
      end
    end

    context 'ログインしていない場合' do
      it '401ステータスが返ってくる' do
        get api_follow_path(account_id: user.id, id: other_user.id)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/account/:account_id/follows' do
    context 'ログインしていて、other_userがuserをfollowしていない場合' do
      before do
        sign_in user
        sign_in other_user
      end

      it 'followできる' do
        post api_follows_path(account_id: user.id)
        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
        expect(body['followersCount']).to eq(1)
      end
    end

    context 'ログインしていて、other_userがuserをすでにfollowしている場合' do
      before do
        sign_in user
        sign_in other_user
        other_user.follow!(user)
      end

      it 'followできない(followerの数が変わらない)' do
        expect {
          post api_follows_path(account_id: user.id)
        }.not_to change { user.followers.count }
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Already following this user')
        expect(body['followersCount']).to eq(1)
      end
    end

    context 'ログインしていない場合' do
      it '401ステータスが返ってくる' do
        post api_follows_path(account_id: user.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
