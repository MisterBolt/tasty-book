# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_recipe, only: [:update, :update_cook_books, :show, :edit, :destroy]


  def index
    @pagy, @recipes = pagy(Recipe.all, items: per_page)
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    @ingredients_recipe = @recipe.ingredients_recipes
    gon.avgScore = @recipe.average_score
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: t(".notice") }
      else
        @recipe.errors.full_messages.each do |e|
          flash.now[:error] = e
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    @recipe.destroy if @recipe.user == current_user || current_user.admin?

    respond_to do |format|
      format.html { redirect_to recipes_path, notice: t(".notice") }
    end
  end

  def update 
    respond_to do |format|
      params = recipe_params
      if !params.key?(:category_ids)
        params[:category_ids] = []
      end
      @recipe.attributes = params
      if @recipe.valid?
        @recipe.save
        format.html { redirect_to @recipe, notice: t(".notice") }
      else
        @recipe.errors.full_messages.each do |e|
          flash.now[:error] = e
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def update_cook_books
    if @recipe.cook_books_update(cook_books_params[:cook_book_ids], current_user)
      flash[:notice] = t(".notice")
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(recipes_path)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :time_in_minutes_needed, :difficulty, :user_id, :layout, category_ids: [], 
      sections_attributes: [:id, :title, :body, :_destroy],
      ingredients_recipes_attributes: [:id, :ingredient_name, :quantity, :unit, :_destroy])
  end

  def cook_books_params
    params.require(:recipe).permit(cook_book_ids: [])
  end
end
