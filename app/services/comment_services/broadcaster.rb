module CommentServices
  class Broadcaster
    def initialize(comment)
      @comment = comment
    end

    def notify_about_created_comment
      update_recipe_comments_list_with_new_comment
    end

    def update_recipe_comments_list_with_new_comment
      recipe_dom_id = ActionView::RecordIdentifier.dom_id(@comment.recipe)
      @comment.broadcast_prepend_to [@comment.recipe, :comments],
        target: "#{recipe_dom_id}_comments"
    end
  end
end
