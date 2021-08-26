# frozen_string_literal: true

class RecipesController < ApplicationController
  DEFAULT_SORT_KIND = "title"
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_recipe, only: [:update, :update_cook_books, :show, :edit, :destroy]
  before_action :validate_sort_params!, only: [:index]

  def index
    @sort_order = sort_order
    @sort_kind = sort_kind
    recipes = Recipe.sort_by_kind_and_order(@sort_kind, @sort_order)
    @pagy, @recipes = pagy(recipes, items: per_page)
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    @ingredients_recipe = @recipe.ingredients_recipes
    gon.avgScore = @recipe.average_score
  end

  def new
    @recipe = Recipe.new
    @ingredients = []
  end

  def edit
    set_ingredients
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      redirect_to(@recipe, notice: t(".notice"))
    else
      flash[:error] = @recipe.errors.full_messages.join(". ") + "."
      @ingredients = []
      if recipe_params.has_key?(:ingredients_recipes_attributes)
        recipe_params[:ingredients_recipes_attributes].values.each do |i|
          if i[:_destroy] != 1
            @ingredients.append(i.except(:_destroy))
          end
        end
      end
      redirect_to(new_recipe_path)
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
      if !params.key?(:ingredients_recipes_attributes)
        IngredientsRecipe.where(recipe_id: @recipe.id).destroy_all
        params[:ingredients_recipes_attributes] = {}
      end
      @recipe.attributes = params
      if @recipe.valid? && params[:ingredients_recipes_attributes] != {}
        IngredientsRecipe.where(recipe_id: @recipe.id).destroy_all
        @recipe.save
        format.html { redirect_to @recipe, notice: t(".notice") }
      else
        set_ingredients
        flash.now[:error] = @recipe.errors.full_messages.join(". ") + "."
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
    redirect_back(fallback_location: recipes_path)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :preparation_description, :time_in_minutes_needed, :difficulty, :user_id, :layout, category_ids: [],
      ingredients_recipes_attributes: [:id, :ingredient_name, :quantity, :unit, :_destroy])
  end

  def cook_books_params
    params.require(:recipe).permit(cook_book_ids: [])
  end

  def set_ingredients
    @ingredients = []
    IngredientsRecipe.where("recipe_id=#{@recipe.id}").each do |i|
      j = {ingredient_name: i.ingredient.name, quantity: i.quantity, unit: IngredientsRecipe.units[i.unit]}
      @ingredients.append(j)
    end
  end

  def validate_sort_params!
    sort_params = params.permit(:page, :items, :kind, :order)
    validator = RecipesSortParamsValidator.new(sort_params)
    return if validator.valid?
    redirect_to recipes_path
  end

  def sort_kind
    params[:kind].presence || DEFAULT_SORT_KIND
  end
end
