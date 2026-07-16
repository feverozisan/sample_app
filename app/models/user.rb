class User < ApplicationRecord
  # 仮想の属性（remember_token）を定義
  attr_accessor :remember_token

  # メールアドレスをすべて小文字にして保存する（一意性の確保のため）
  before_save { self.email = email.downcase }

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
  
  # パスワードのバリデーション（空でないこと、6文字以上であること）
  validates :password, presence: true, length: { minimum: 6 }

  # 渡されたトークンがダイジェストと一致したらtrue を返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

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
end
