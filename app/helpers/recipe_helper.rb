module RecipeHelper
  def recipes_sort_options
    {
      kind: {
        "By title": "title",
        "By score": "score",
        "By time": "time_in_minutes_needed",
        "By difficulty": "difficulty"
      },
      order: {
        Ascending: "ASC",
        Descending: "DESC"
      }
    }
  end
end
