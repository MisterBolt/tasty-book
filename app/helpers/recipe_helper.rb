module RecipeHelper
  IMAGE_CLASS = "flex-none rounded-lg object-cover bg-gray-100"
  IMAGE_ALT = "image showing dish"
  IMAGE_DEFAULT = "https://res.cloudinary.com/hp7f0176d/image/upload/v1629832221/sample/default_recipe_u9wld9.png"
  IMAGE_THUMBNAIL_DEFAULT = "https://res.cloudinary.com/hp7f0176d/image/upload/v1629832231/sample/default_recipe_thumbnail_yarrcr.png"

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

  def recipe_image_for_index(recipe)
    if recipe.image.attached?
      image_tag(recipe.image.variant(resize_to_fill: [100, 100]), class: IMAGE_CLASS, alt: IMAGE_ALT)
    else
      image_tag(IMAGE_THUMBNAIL_DEFAULT, class: IMAGE_CLASS)
    end
  end

  def recipe_image_for_layout1(recipe)
    if recipe.image.attached?
      image_tag(recipe.image.variant(resize_to_fill: [1280, 1600]), class: IMAGE_CLASS, alt: IMAGE_ALT)
    else
      image_tag(IMAGE_DEFAULT, class: IMAGE_CLASS)
    end
  end

  def recipe_image_for_layout2(recipe)
    if recipe.image.attached?
      image_tag(recipe.image.variant(resize_to_fill: [1280, 256]), class: IMAGE_CLASS, alt: IMAGE_ALT)
    else
      image_tag(IMAGE_DEFAULT, class: IMAGE_CLASS)
    end
  end

  def recipe_image_for_layout3(recipe)
    if recipe.image.attached?
      image_tag(recipe.image, class: IMAGE_CLASS, alt: IMAGE_ALT)
    else
      image_tag(IMAGE_DEFAULT, class: IMAGE_CLASS)
    end
  end

  def authorize_recipe_action_links?(recipe)
    user_signed_in? && (recipe.user == current_user || current_user.admin?)
  end

  def filter_books_button_class(my_books, btn)
    button_class = "flex items-center font-medium shadow-md p-3 border border-gray-300 font-medium cursor-pointer"
    active_button_class = "bg-gray-400 text-white"
    unactive_button_class = "bg-gray-200 text-gray-700 hover:bg-gray-300"
    if btn == t("filters.buttons.my_books")
      return "#{(@my_books == "1" ? active_button_class : unactive_button_class)} #{button_class} rounded-l-lg"
    else
      return "#{( @my_books != "1" ? active_button_class : unactive_button_class)} #{button_class} rounded-r-lg"
    end
  end
end
