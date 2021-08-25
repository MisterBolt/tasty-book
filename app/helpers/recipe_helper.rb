module RecipeHelper
  def recipes_sort_options
    {
      kind: {
        "#{t("sort.by_title")}": "title",
        "#{t("sort.by_score")}": "score",
        "#{t("sort.by_time")}": "time_in_minutes_needed",
        "#{t("sort.by_difficulty")}": "difficulty"
      },
      order: {
        "#{t("sort.ascending")}": "ASC",
        "#{t("sort.descending")}": "DESC"
      }
    }
  end
end
