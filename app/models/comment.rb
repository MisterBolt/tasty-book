class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user, optional: true
  validates_presence_of :body
  after_create_commit -> { CommentServices::Broadcaster.new(self).notify_about_created_comment }
end
