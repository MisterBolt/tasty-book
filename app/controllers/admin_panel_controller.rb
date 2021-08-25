# frozen_string_literal: true

class AdminPanelController < ApplicationController
  def comments
    @comments = Comment.awaiting
  end
end
