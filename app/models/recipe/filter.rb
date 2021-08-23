class Recipe::Filter
  def filter(scope, query_params)
    if query_params[:text].present?
      scope = scope.where("LOWER(recipes.title) LIKE :text", text: "%#{query_params[:text].downcase}%")
    end

    if query_params[:my_books] == '1' && query_params[:current_user]
      scope = scope.joins(:cook_books).where(cook_books: {user_id: query_params[:current_user]})
    end

    scope
  end
end
