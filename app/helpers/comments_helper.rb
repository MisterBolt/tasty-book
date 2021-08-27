module CommentsHelper
  def avatar_with_or_without_href(comment, size)
    if comment.user.present?
      render("comments/avatar_with_href", image: avatar_for_user_or_guest(comment.user||nil), href: user_path(comment.user), size: size)
    else
      render("comments/avatar_without_href", image: avatar_for_user_or_guest(comment.user||nil), size: size)
    end
  end
end
