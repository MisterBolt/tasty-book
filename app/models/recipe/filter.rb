class Recipe::Filter
  def filter(scope, query_params)
    if query_params[:text].present?
      scope = scope.where("LOWER(title) LIKE :text", text: "%#{query_params[:text].downcase}%")
    end

    if query_params[:my_books] == "1" && query_params[:current_user]
      scope = scope.joins(:cook_books).where(cook_books: {user_id: query_params[:current_user]})
    end

    if query_params[:difficulties].present?
      difficulties = query_params[:difficulties].map(&:to_i)
      scope = scope.where("difficulty IN (?)", difficulties)
    end

    if query_params[:categories].present?
      scope = scope.joins(:categories).where("categories.name IN (?)", query_params[:categories])
    end

    if query_params[:ingredients].present?
      scope = scope.joins(:ingredients).where("ingredients.name IN (?)", query_params[:ingredients])
    end
    
    if query_params[:time].present?
      scope = case query_params[:time]
      when "all"
        scope.all
      when "less_than_15_minutes"
        scope.where("time_in_minutes_needed < 15")
      when "less_than_30_minutes"
        scope.where("time_in_minutes_needed < 30")
      when "less_than_hour"
        scope.where("time_in_minutes_needed < 60")
      else
        scope.where("time_in_minutes_needed >= 60")
      end
    end

    scope
  end
end
