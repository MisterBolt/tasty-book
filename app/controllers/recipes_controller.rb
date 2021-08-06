# frozen_string_literal: true

class RecipesController < ApplicationController
  include RecipeScoreHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_recipe, only: [:update, :update_cook_books, :show, :edit, :destroy]

  def index
    @pagy, @recipes = pagy(Recipe.all, items: per_page)
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    @ingredients_recipe = @recipe.ingredients_recipes
    gon.avgScore = average_recipe_score(@recipe)
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  def create
    @recipe = Recipe.new(recipe_params)
    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: t(".notice") }
      else
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
    if @recipe.update(recipe_params)
      flash[:notice] = t(".notice")
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(@recipe)
  end

  def update_cook_books
    if cook_books_updated?
      flash[:notice] = t(".notice")
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(recipes_path)
  end

  private

  def cook_books_updated?
    cook_book_id_strings = cook_books_params[:cook_book_ids].filter { |cook_book_id| cook_book_id != "" }
    cook_book_ids = cook_book_id_strings.map { |cook_book_id| cook_book_id.to_i }
    if cook_book_ids.all? { |cook_book_id| current_user.cook_books.ids.include?(cook_book_id) }
      @recipe.cook_books.delete(CookBook.where(user_id: current_user.id))
      @recipe.cook_books << CookBook.where(id: cook_book_ids)
    else
      false
    end
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :preparation_description, :time_in_minutes_needed)
  end

  def cook_books_params
    params.require(:recipe).permit(cook_book_ids: [])
  end
end
