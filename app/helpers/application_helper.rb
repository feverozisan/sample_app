module ApplicationHelper

  # ページごとに完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # 💡【ここを修正します】
  # 引数に「options = { size: 80 }」を追加し、内部で size 変数を使うように書き換えます
  def gravatar_for(user, options = { size: 80 })
    size         = options[:size]
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://gravatar.com{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  # 以下のメソッドをまるごと追加します
  def bootstrap_will_paginate(collection, options = {})
    options = options.merge(
      renderer: WillPaginate::ActionView::LinkRenderer,
      class: 'pagination justify-content-center' # Bootstrapの見た目を適用
    )
    will_paginate(collection, options)
  end
end
