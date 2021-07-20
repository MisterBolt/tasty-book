# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :destroy]

  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: per_page)
  end

  def show
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
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_path, notice: t(".notice") }
    end
  end

  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: t(".notice") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :description)
  end
end
