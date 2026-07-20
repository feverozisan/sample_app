require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
    test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    
    # 💡 【ここを 5 から 4 に修正します】
    assert_select "div.alert", "The form contains 4 errors."
  end


  test "successful edit with friendly forwarding" do
    # 1. ログインしていない状態で編集ページにアクセス
    get edit_user_path(@user)
    
    # 2. ログインする（これで自動的に編集ページへ転送される）
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    
    # 3. 転送された状態のまま、プロフィールを更新（patch）する
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    
    # 4. フラッシュメッセージが表示され、プロフィール画面に遷移することを確認
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
