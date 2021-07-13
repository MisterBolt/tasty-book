class RecipeController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def edit

  end

  def create
    @recipe = Recipe.new(recipe_params)
    respond_to do
      if @recipe.save
        format.html { redirect_to @recipe, notice: "Recipe was successfully created."}
        format.json { render :show, status: :created, location: @recipe}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render :json, @recipe.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipe_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: "Recipe was successfully updated." }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description)
  end
end
