require 'rails_helper'

RSpec.describe 'Api::V1::Follows', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'POST /api/account/:account_id/unfollows' do
    context 'ログインしていて、other_userがuserをfollowしている場合' do
      before do
        sign_in user
        sign_in other_user
        other_user.follow!(user)
      end

      it 'unfollowできる' do
        post api_unfollows_path(account_id: user.id)
        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
        expect(body['followersCount']).to eq(0)
      end
    end

    context 'ログインしていて、other_userがuserをfollowしていない場合' do
      before do
        sign_in user
        sign_in other_user
      end

      it 'unfollowできない(followerの数が変わらない)' do
        expect {
          post api_unfollows_path(account_id: user.id)
        }.not_to change { user.followers.count }
        body = JSON.parse(response.body)
        expect(body['error']).to eq('You are not yet following user')
        expect(body['followersCount']).to eq(0)
      end
    end

    context 'ログインしていない場合' do
      it '401ステータスが返ってくる' do
        post api_unfollows_path(account_id: user.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
