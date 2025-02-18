require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let!(:user) { create(:user) }
  let!(:followers) { create_list(:user, 3) }
  let!(:followings) { create_list(:user, 2) }

  describe "GET /accounts/:account_id/follows" do
    context 'ログインしていて、userがfollowされている場合' do
      before do
        sign_in user
        followers.each { |follower| follower.follow!(user) }
      end

      it "follower一覧が表示される" do
        get account_follows_path(account_id: user.id)
        expect(response).to have_http_status(200)

        followers.each do |follower|
          expect(response.body).to include(follower.username)
          expect(response.body).to include(account_path(follower))
        end
      end
    end

    context 'ログインしていて、userがfollowしている場合' do
      before do
        sign_in user
        followings.each { |following| user.follow!(following) }
      end
      it "following一覧が表示される" do
        get account_follows_path(account_id: user.id, tab: "Following")
        expect(response).to have_http_status(200)

        followings.each do |following|
          expect(response.body).to include(following.username)
          expect(response.body).to include(account_path(following))
        end
      end
    end

    context 'ログインしていて、誰にもuserがfollowされていない場合' do
      before do
        sign_in user
      end
      it "200ステータスが返ってくる" do
        get account_follows_path(account_id: user.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていて、userが誰もfollowしていない場合' do
      before do
        sign_in user
      end
      it "200ステータスが返ってくる" do
        get account_follows_path(account_id: user.id, tab: "Following")
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get account_follows_path(account_id: user.id)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
