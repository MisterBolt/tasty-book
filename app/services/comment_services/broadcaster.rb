module CommentServices
  class Broadcaster
    def initialize(comment)
      @comment = comment
    end

    def process_created_comment
      update_recipe_comments_list_with_new_comment
      update_awaiting_comments_list_with_new_comment
      update_number_of_awaiting_comments
      notify_about_created_comment
    end

    def process_destroyed_comment
      update_recipe_comments_list_with_new_comment
      update_awaiting_comments_list_with_destroyed_comment
      update_number_of_awaiting_comments
    end

    def update_recipe_comments_list_with_new_comment
      if @comment.status_approved?
        recipe_dom_id = ActionView::RecordIdentifier.dom_id(@comment.recipe)
        @comment.broadcast_prepend_to [@comment.recipe, :comments],
          target: "#{recipe_dom_id}_comments",
          viewable: true
      end
    end

    def update_awaiting_comments_list_with_new_comment
      if @comment.status_awaiting?
        @comment.broadcast_append_to(
          :admin_comments,
          target: "admin_comments",
          locals: {viewable: true, comment: @comment}
        )
      end
    end

    def update_awaiting_comments_list_with_destroyed_comment
      comment_dom_id = ActionView::RecordIdentifier.dom_id(@comment)
      @comment.broadcast_remove_to(
        :admin_comments,
        target: "#{comment_dom_id}_comment"
      )
    end

    def update_number_of_awaiting_comments
      ["comments_left", "no_comments_left"].each do |target|
        @comment.broadcast_replace_to(
          target,
          target: target,
          partial: "admin_panels/#{target}",
          locals: {comments_size: Comment.awaiting.size}
        )
      end
    end

    def notify_about_created_comment
      @comment.broadcast_append_to :notifications,
        target: "#{@comment.recipe.user.id}_toast",
        partial: "shared/toast",
        locals: {message: @comment.user_id.nil? ?
                    I18n.t("notifications.guest_comment", title: @comment.recipe.title) :
                    I18n.t("notifications.comment", title: @comment.recipe.title, user: @comment.user.username)}
    end
  end
end
