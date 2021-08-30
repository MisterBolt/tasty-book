class RecipeScore < ApplicationRecord
  SCORE = (1..5).to_a.freeze

  validates :user_id, presence: true, uniqueness: {scope: :recipe_id}
  validates :recipe_id, presence: true
  validates :score, presence: true, inclusion: {in: SCORE}

  belongs_to :user
  belongs_to :recipe

  after_create_commit -> { RecipeScoreServices::Broadcaster.new(self).notify_about_new_score }

  def send_notification_email
    NotificationMailer.recipe_score_notification(recipe.user, self).deliver_now unless recipe.user.deleted?
  end
end
