class SessionsController < ApplicationController
  def new
  end


  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &.authenticate(params[:session][:password])
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

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
