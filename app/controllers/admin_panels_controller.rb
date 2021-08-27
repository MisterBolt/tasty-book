# frozen_string_literal: true

class AdminPanelsController < ApplicationController
  before_action :require_admin
  before_action :set_comment, only: [:comment_approve, :comment_reject]
  after_action :save_comment, only: [:comment_approve, :comment_reject]

  def show
    # TODO: show view for admin panel
    redirect_to(comments_admin_panel_path)
  end

  def comments
    @comments = Comment.awaiting
  end

  def comment_approve
    @comment.status = :approved
  end

  def comment_reject
    @comment.status = :rejected
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def save_comment
    @comment.save
  end
end
