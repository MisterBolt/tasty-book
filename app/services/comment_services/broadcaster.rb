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
        locals: {message: @comment.user_id.nil? ?
                    I18n.t("notifications.guest_comment", title: @comment.recipe.title) :
                    I18n.t("notifications.comment", title: @comment.recipe.title, user: @comment.user.username)}
    end

    def locale_to_hash
      hash = YAML.load_file("config/locales/en.yml")
      puts hash
    end
  end
end
