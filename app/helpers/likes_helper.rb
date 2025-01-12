module LikesHelper
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
end