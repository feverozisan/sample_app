source "https://rubygems.org"

ruby "4.0.5"

# Rails本体
gem "rails", "~> 7.2.2"
gem "image_processing","1.12.2"
gem 'active_storage_validations', '0.9.8' # バージョンはチュートリアルの指定に合わせてください
# データベース (チュートリアル2章用)
gem "sqlite3", ">= 1.6.1"

# サーバー・起動最適化
gem "puma", ">= 5.0"
gem "bootsnap", ">= 1.24.0", require: false

# チュートリアルで使う一般的なフロントエンド・ユーティリティ
gem "jbuilder", ">= 2.12.0"
gem "stimulus-rails"
gem "turbo-rails"
# この1行を追加します
gem "importmap-rails"
gem "sprockets-rails"
gem "bootstrap-sass"
gem "sassc-rails"
gem "bcrypt"
gem "faker"
gem "will_paginate"
gem 'rails-controller-testing'

group :production do
  gem "aws-sdk-s3","1.229.0", require: false
end

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "minitest", "~> 5.0"
end

group :development do
  gem "web-console"
end
