class NotificationMailer < ApplicationMailer
  def comment_notification(user, comment)
    @user = user
    @comment = comment
    mail to: user.email, subject: "Comment notification"
  end

  def follow_notification(user, follower)
    @user = user
    @follower = follower
    mail to: user.email, subject: "Follow notification"
  end

  def recipe_score_notification(user, recipe_score)
    @user = user
    @recipe_score = recipe_score
    mail to: user.email, subject: "Recipe score notification"
  end
end
