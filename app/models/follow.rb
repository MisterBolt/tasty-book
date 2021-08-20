class Follow < ApplicationRecord
  # The user giving the follow
  belongs_to :follower,
    class_name: "User"
  # The user being followed
  belongs_to :followed_user,
    class_name: "User"
    
  after_create_commit -> { FollowServices::Broadcaster.new(self).notify_about_new_follower }

  def send_notification_email
    NotificationMailer.follow_notification(followed_user, follower).deliver_now
  end
end
