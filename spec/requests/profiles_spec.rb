require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let!(:user) { create(:user) }

  describe 'GET /profile' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200ステータスが返ってくる' do
        get profile_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it 'ログイン画面に遷移する' do
        get profile_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT /profile' do
    context "ログインしている場合" do
      before do
        sign_in user
        user.prepare_profile  # profileを準備する
      end
      it "avatarが更新できる" do
        expect(user.profile).to be_present
        avatar_file = fixture_file_upload(Rails.root.join('app/assets/images/test1.png'), 'image/png')
        put profile_path, params: { profile: { avatar: avatar_file } }

        expect(response).to have_http_status(302)
        user.profile.reload
        expect(user.profile.avatar).to be_attached
        expect(user.profile.avatar.filename.to_s).to eq('test1.png')
      end
    end

    context "ログインしていない場合" do
      it 'ログイン画面に遷移する' do
        put profile_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
