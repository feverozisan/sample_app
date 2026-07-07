module ApplicationHelper

    # ページごとの完全なタイトルを返す
    def full_title(page_title = '')
        base_title = "Ruby on Rails Tutorial Sample App"
        if page_title.empty?
            base_title
        else
            "#{page_title} | #{base_title}"
        end
    end
end

module UsersHelper
# 引数で与えられたユーザーのGravatar 画像を返す
    def gravatar_for(user)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
end