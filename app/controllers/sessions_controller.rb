class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # 1. 転送先URLをあらかじめ退避させる
      forwarding_url = session[:forwarding_url]
      
      # 2. セッションをリセット
      reset_session
      
      # 3. ログインと永続化処理
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      
      # 4. 退避させていたURLへリダイレクトし、セッションを削除する
      # ※ reset_session の後に代入し直すことで安全に機能させます
      session[:forwarding_url] = forwarding_url
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
