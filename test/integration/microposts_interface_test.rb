# test/integration/microposts_interface_test.rb
require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Homeページにファイルアップロードタグがあるかチェック
    assert_select 'input[type=file]'

    # 無効な送信（省略）

    # 有効な送信
    content = "This micropost really ties the room together"
    # fixture_file_uploadでテスト用画像を準備
    image = fixture_file_upload('kitten.jpg', 'image/jpeg')

    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, image: image } }
    end

    # 【ヒントの対応】assignsを使って@micropostのimage属性が有効かチェック
    assert assigns(:micropost).image.attached?

    # 投稿成功後のリダイレクト先（Homeページ）に移動
    follow_redirect!
    assert_match content, response.body
    # 投稿した画像がページ上に表示されているか（imgタグがあるか）チェック
    assert_select 'img'
  end
end
