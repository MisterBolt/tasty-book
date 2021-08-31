class Recipe::Filter
  def filter(scope, filters_params)
    if filters_params[:my_books] == "1" && filters_params[:current_user].present?
      scope = scope.joins(:cook_books).where(cook_books: {user_id: filters_params[:current_user].id})
    end

    if filters_params[:search].present? && filters_params[:search] != ""
      scope = scope.searched(filters_params[:search])
    end

    if filters_params[:difficulties].present?
      difficulties = filters_params[:difficulties].map(&:to_i)
      scope = scope.where("difficulty IN (?)", difficulties)
    end

    if filters_params[:categories].present?
      scope = scope.joins(:categories).where("categories.name IN (?)", filters_params[:categories])
    end

    if filters_params[:ingredients].present?
      scope = scope.joins(:ingredients).where("ingredients.name IN (?)", filters_params[:ingredients])
    end

    if filters_params[:time].present?
      scope = case filters_params[:time]
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

    if filters_params[:kind].present? && filters_params[:order].present?
      scope = sort(scope, filters_params[:kind], filters_params[:order])
    end
  end

  def sort(scope, kind, order)
    case kind
    when "title", "difficulty", "time_in_minutes_needed"
      scope = scope.order(kind => order)
    when "score"
      nulls_presence = order == "DESC" ? "NULLS LAST" : "NULLS FIRST"
      scope = scope.left_outer_joins(:recipe_scores)
        .select("recipes.*")
        .group("recipes.id")
        .order("avg(recipe_scores.score) #{order} #{nulls_presence}")
    end
    scope
  end
end
