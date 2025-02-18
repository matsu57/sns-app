require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe "GET /accounts/:id" do
    context "viewを開いたuserがカレントユーザーである場合" do
      before do
        sign_in user
      end

      it 'プロフィールページへ遷移する' do
        get account_path(user)
        expect(response).to redirect_to(profile_path)
      end
    end

    context "viewを開いたuserが他のユーザーである場合" do
      before do
        sign_in user
      end

      it '200ステータスが返ってくる' do
        get account_path(other_user)
        expect(response).to have_http_status(200)
      end
    end
  end
end
