class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      # 🔵 必ず if の中（end の前）に記述します
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  # 第3章の演習（Contactページ）も入っている場合は、以下も追加します
  def contact
  end
end