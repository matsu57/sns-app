require 'rails_helper'

RSpec.describe 'Api::V1::Follows', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:followers) { create_list(:user, 3) }
  let!(:followings) { create_list(:user, 2) }

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
end
