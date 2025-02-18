require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let!(:user) { create(:user) }
  let!(:followers) { create_list(:user, 3) }
  let!(:followings) { create_list(:user, 2) }

  before do
    followers.each { |follower| follower.follow!(user) }
    followings.each { |following| user.follow!(following) }
    sign_in user
  end

  describe "GET /accounts/:account_id/follows" do
    it "follower一覧が表示される" do
      get account_follows_path(account_id: user.id)
      expect(response).to have_http_status(200)

      followers.each do |follower|
        expect(response.body).to include(follower.username)
        expect(response.body).to include(account_path(follower))
      end
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
end
