class NotificationMailerPreview < ActionMailer::Preview
  def comment_notification
    user = FactoryBot.create(:user)
    comment = FactoryBot.create(:comment)
    NotificationMailer.comment_notification(user, comment)
  end

  def follow_notification
    followed_user = FactoryBot.create(:user)
    follower = FactoryBot.create(:user)
    NotificationMailer.follow_notification(followed_user, follower)
  end

  def recipe_score_notification
    user = FactoryBot.create(:user)
    recipe_score = FactoryBot.create(:recipe_score, recipe_id: recipe.id)
    NotificationMailer.recipe_score_notification(user, recipe_score)
  end
end