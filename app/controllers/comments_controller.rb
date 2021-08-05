class CommentsController < ApplicationController
  before_action :set_recipe
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @comment = current_user.comments.new(**comment_params, recipe_id: @recipe.id)
    respond_to do |format|
      if @comment.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("comment_form",
            partial: "comments/form", locals: {comment: Comment.new})
        }
        format.html { render partial: "comments/form", locals: {comment: Comment.new} }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("comment_form",
            partial: "comments/form", locals: {comment: @comment})
        }
        format.html { render partial: "comments/form", locals: {comment: @comment} }
      end
    end
  end

  def destroy
    @comment = @recipe.comments.find(params[:id])
    @comment.destroy
    redirect_to @recipe
    flash[:notice] = t(".notice")
  end

  private

  def set_recipe
    @recipe ||= Recipe.find(params[:recipe_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
