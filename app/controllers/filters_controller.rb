class FiltersController < ApplicationController
  def index
    respond_to do |format|
      format.turbo_stream {
        params = query_params
        @pagy, @recipes = pagy(Recipe.searched(params[:text]), items: per_page)
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
    query_params ? query_params.permit(:text) : {}
  end
end
