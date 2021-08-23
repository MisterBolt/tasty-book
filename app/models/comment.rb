class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user, optional: true
  validates_presence_of :body

  after_create_commit -> { CommentServices::Broadcaster.new(self).process_created_comment }

  def send_notification_email
    NotificationMailer.comment_notification(recipe.user, self).deliver_now
  end
end
