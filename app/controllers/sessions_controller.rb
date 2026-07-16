class SessionsController < ApplicationController

  def new
  end

  def create
    # ⭕ `?user` になっていた場所をすべて `@user` に修正
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      reset_session
      
      # ⭕ Remember me のチェックボックスによる条件分岐
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      
      log_in @user
      redirect_to @user
    else
      # ❌ ログイン失敗時：エラーメッセージを出して、ログイン画面を再表示する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
