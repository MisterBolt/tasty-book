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
    @ingredients = []
    @sections = []
  end

  def edit
    set_ingredients
    set_sections
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
        @ingredients = recipe_params.has_key?(:ingredients_recipes_attributes) ? recipe_params[:ingredients_recipes_attributes].values : []
        @sections = recipe_params.has_key?(:sections_attributes) ? recipe_params[:sections_attributes].values : []
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
      params = validate_params(params)
      @recipe.attributes = params
      if @recipe.valid? && params[:ingredients_recipes_attributes] != {} && params[:sections_attributes] != {}
        IngredientsRecipe.where(recipe_id: @recipe.id).destroy_all
        Section.where(recipe_id: @recipe.id).destroy_all
        @recipe.save
        format.html { redirect_to @recipe, notice: t(".notice") }
      else
        set_ingredients
        set_sections
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
      sections_attributes: [:id, :title, :body],
      ingredients_recipes_attributes: [:id, :ingredient_name, :quantity, :unit])
  end

  def cook_books_params
    params.require(:recipe).permit(cook_book_ids: [])
  end

  def set_ingredients
    @ingredients = []
    for i in IngredientsRecipe.where(recipe_id: @recipe.id) do
      j = { ingredient_name: i.ingredient.name, quantity: i.quantity, unit: IngredientsRecipe.units[i.unit] }
      @ingredients.append(j)
    end
  end

  def set_sections
    @sections = []
    for i in Section.where(recipe_id: @recipe.id) do
      j = { title: i.title, body: i.body }
      @sections.append(j)
    end
  end

  def validate_params(params)
    if !params.key?(:category_ids)
      params[:category_ids] = []
    end
    if !params.key?(:ingredients_recipes_attributes)
      params[:ingredients_recipes_attributes] = {}
    end
    if !params.key?(:sections_attributes)
      params[:sections_attributes] = {}
    end
    params
  end
end
