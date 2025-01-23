module ArticlesHelper
  def likes_count_display(article)
    count = article.likes.count
    return '' if count == 0

    last_user = article.likes.last&.user&.username
    if count == 1
      "#{last_user} liked your post"
    else
      "#{last_user} and #{count - 1} other#{count > 2 ? 's' : ''} liked your post"
    end
  end

  def comments_count_display(article)
    count = article.comments.count
    if count > 0
      content_tag(:p, count)
    end
  end

  def display_create_at(article)
    hours_ago = ((Time.zone.now - article.created_at) / 1.hour).floor
    if hours_ago > 24
      I18n.l(article.created_at, format: :default)
    else
      "#{hours_ago} hours ago"
    end
  end

  def image_count_class(article, detail = false)
    return if detail
    "image-count-#{article.images.length}"
  end
end