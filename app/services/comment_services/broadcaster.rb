module CommentServices
  class Broadcaster
    def initialize(comment)
      @comment = comment
    end

    def process_created_comment
      update_recipe_comments_list_with_new_comment
      notify_about_created_comment
    end

    def update_recipe_comments_list_with_new_comment
      recipe_dom_id = ActionView::RecordIdentifier.dom_id(@comment.recipe)
      @comment.broadcast_prepend_to [@comment.recipe, :comments],
        target: "#{recipe_dom_id}_comments"
    end

    def notify_about_created_comment
      @comment.broadcast_append_to :notifications,
        target: "#{@comment.recipe.user.id}_toast",
        partial: "shared/toast",
        locals: {message: "Your #{@comment.recipe.title} recipe has been commented by #{@comment.user.nil? ? "guest" : @comment.user.username}"}
    end
  end
end
