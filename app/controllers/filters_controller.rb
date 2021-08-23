class FiltersController < ApplicationController
  def index
    respond_to do |format|
      format.turbo_stream {
        params = query_params
        params[:current_user] = current_user.id
        @pagy, @recipes = pagy(Recipe.filtered(params), items: per_page)
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
    query_params ? query_params.permit(:text, :time, :my_books, categories: [], ingredients: [], difficulties: []) : {}
  end
end
