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

  def recipe_image_for(recipe, img_variant)
    image_tag(check_image(recipe, img_variant), class: "flex-none rounded-lg object-cover bg-gray-100", alt: "", size: "100x100")
  end

  def check_image(recipe, img_variant)
    if recipe.image.attached?
      case img_variant
      when :thumbnail
        recipe.image.variant(resize_to_fill: [100, 100])
      when :layout1
        recipe.image.variant(resize_to_fill: [1280, 1600])
      when :layout2
        recipe.image.variant(resize_to_fill: [1280, 256])
      when :layout3
        recipe.image
      end
    elsif img_variant == :thumbnail
      "https://res.cloudinary.com/hp7f0176d/image/upload/v1629832231/sample/default_recipe_thumbnail_yarrcr.png"
    else
      "https://res.cloudinary.com/hp7f0176d/image/upload/v1629832221/sample/default_recipe_u9wld9.png"
    end
  end
end
