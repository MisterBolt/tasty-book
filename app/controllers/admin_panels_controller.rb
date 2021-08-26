# frozen_string_literal: true

class AdminPanelsController < ApplicationController
  before_action :require_admin

  def show
    # TODO: show view for admin panel
    redirect_to(comments_admin_panel_path)
  end

  def comments
    @comments = Comment.awaiting
  end
end
