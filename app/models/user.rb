class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest

  # 名前のバリデーション（空でないこと、50文字以内であること）
  validates :name,  presence: true, length: { maximum: 50 }

  # メールアドレスのバリデーション（空でないこと、255文字以内であること、正しい形式であること、重複しないこと）
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # 1. 存在チェックとフォーマットチェック
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  # 2. 一意性チェック（大文字小文字を区別しない）を完全に独立させる
  validates :email, uniqueness: { case_sensitive: false }


  # セキュアなパスワード機能を追加（password, password_confirmation の自動追加、authenticateメソッドの有効化）
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # パスワードのバリデーション（空でないこと、6文字以上であること）
  #validates :password, presence: true, length: { minimum: 6 }

  # ユーザーをデータベースに記憶する（永続セッション用）
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # ユーザーのログイン情報を破棄する（ログアウト用）
  def forget
    update_attribute(:remember_digest, nil)
  end

  # クラスメソッドの定義
  class << self
    # 渡された文字列のハッシュ（暗号化）値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークン（文字列）を返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 渡されたトークンがダイジェストと一致したらtrue を返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
