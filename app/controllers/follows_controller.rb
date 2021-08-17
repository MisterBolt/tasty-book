class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_user_id])
    @follow = current_user.follow(@user)
    flash[:notice] = t(".notice")
    @follow.send_notification_email
    redirect_back fallback_location: @user
  end

  def destroy
    @user = Follow.find_by(followed_user_id: params[:id]).followed_user
    current_user.unfollow(@user)
    flash[:notice] = t(".notice")
    redirect_back fallback_location: @user
  end
end
