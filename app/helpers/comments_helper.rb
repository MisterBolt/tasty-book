module CommentsHelper
  def avatar_with_or_without_href(comment, size)
    if comment.user.present?
      render("comments/avatar_with_href", image: comment.default_or_user_avatar, href: user_path(comment.user), size: size)
    else
      render("comments/avatar_without_href", image: comment.default_or_user_avatar, size: size)
    end
  end
end
