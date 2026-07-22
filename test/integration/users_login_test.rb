require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # 無効な情報でのログインテスト
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert_empty flash
  end

  # 有効な情報でのログイン・ログアウトテスト
  test "login with valid information followed by logout" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # ログアウト処理
    delete logout_path
    assert_not is_logged_in? # ⭕ ログアウト後に未ログイン状態（false）であることを正しく検証
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

# 「Remember me」機能用の独立したテストクラス（重複なし）
class RememberingTest < UsersLoginTest

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    # クッキーが削除されていることを検証してログイン
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank? # 💡 assert_nil に変更
  end
end
