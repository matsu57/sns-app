require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  let!(:user) { create(:user) }
  let!(:followers) { create_list(:user, 3) }
  let!(:followings) { create_list(:user, 2) }

  describe 'GET /accounts/:account_id/follows' do
    context 'userがfollowされている場合' do
      before do
        followers.each { |follower| follower.follow!(user) }
      end

      it 'follower一覧が表示される' do
        get account_follows_path(account_id: user.id)
        expect(response).to have_http_status(200)

        followers.each do |follower|
          expect(response.body).to include(follower.username)
          expect(response.body).to include(account_path(follower))
        end
      end
    end

    context 'userがfollowしている場合' do
      before do
        followings.each { |following| user.follow!(following) }
      end
      it 'following一覧が表示される' do
        get account_follows_path(account_id: user.id, tab: 'Following')
        expect(response).to have_http_status(200)

        followings.each do |following|
          expect(response.body).to include(following.username)
          expect(response.body).to include(account_path(following))
        end
      end
    end

    context '誰にもuserがfollowされていない場合' do
      it '200ステータスが返ってくる' do
        get account_follows_path(account_id: user.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'userが誰もfollowしていない場合' do
      it '200ステータスが返ってくる' do
        get account_follows_path(account_id: user.id, tab: 'Following')
        expect(response).to have_http_status(200)
      end
    end
  end
end
