class CommentsController < ApplicationController
  before_action :set_recipe
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @comment = current_user.comments.new(**comment_params, recipe_id: @recipe.id)
    redirect_to recipe_path(@recipe)
    return flash[:notice] = "Comment was created successfully." if @comment.save
    flash[:danger] = "error"
  end

  def destroy
    @comment = @recipe.comments.find(params[:id])
    @comment.destroy
    redirect_to(recipe_path(@recipe), info: "Destroyed!")
  end

  private

  def set_recipe
    @recipe ||= Recipe.find(params[:recipe_id])
  end

  def comment_params
    params.require(:comment).permit(:user, :body)
  end
end
