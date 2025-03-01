module LoginHelper
  def login_as(user)
    visit login_path # ログイン画面に遷移
    fill_in 'email', with: user.email # メールアドレスを入力
    fill_in 'password', with: 'password' # パスワードを入力
    click_button 'Login' # ログインボタンをクリック
  end
end