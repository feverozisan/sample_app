require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sessions_new_url
    assert_response :success
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ⭕️ ログイン成功時：ユーザーのプロフィール画面（show）へ移動する
      reset_session      # チュートリアルの指示に従って追加（セッション固定攻撃対策）
      log_in user
      redirect_to user
    else
      # ❌ ログイン失敗時：エラーメッセージを出して、ログイン画面を再表示する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end
end
