class FiltersController < ApplicationController
  def index
    byebug
    respond_to do |format|
      format.turbo_stream {
        @pagy, @recipes = pagy(Recipe.filtered(query_params), items: per_page)
        render turbo_stream: turbo_stream.replace(
          "recipes_listing",
          partial: "recipes/recipes"
        )
      }
    end
  end

  private

  def query_params
    query_params = params[:query]
    query_params ? query_params.permit(:text, :time, categories: [], ingredients: [], difficulties: []) : {}
  end
end
