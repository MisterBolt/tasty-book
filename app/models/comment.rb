class Comment < ApplicationRecord
  enum status: {awaiting: 0, approved: 1, rejected: 2}, _prefix: true

  belongs_to :recipe
  belongs_to :user, optional: true
  validates_presence_of :body
  validates_inclusion_of :status, in: statuses

  after_create_commit -> { CommentServices::Broadcaster.new(self).process_created_comment }

  scope :awaiting, -> { where(status: :awaiting) }
  scope :approved, -> { where(status: :approved) }

  def send_notification_email
    NotificationMailer.comment_notification(recipe.user, self).deliver_now
  end
end
