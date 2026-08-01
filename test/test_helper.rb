ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # 指定のワーカー数でテストを並列実行する（1に制限して競合を防ぐ）
    parallelize(workers: 1)

    # test/fixtures/*.yml の fixture をすべてセットアップする
    fixtures :all

    # ヘルパーとファイルアップロード用モジュールを安全にインクルード
    include ApplicationHelper
    include ActionDispatch::TestProcess::FixtureFile

    # テストユーザーがログイン中の場合に true を返す
    def is_logged_in?
      !session[:user_id].nil?
    end

    # テストユーザーとしてログインする（単体テスト・コントローラーテスト用）
    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする（インテグレーションテスト用）
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
