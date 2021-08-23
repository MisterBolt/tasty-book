module FollowServices
  class Broadcaster
    def initialize(follow)
      @follow = follow
    end

    def notify_about_new_follower
      @follow.broadcast_append_to :notifications,
        target: "#{@follow.followed_user.id}_toast",
        partial: "shared/toast",
        locals: {message: I18n.t("notifications.follow", follower: @follow.follower.username)}
    end
  end
end
