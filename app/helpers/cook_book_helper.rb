module CookBookHelper
  def cook_book_recipes_text(recipes)
    recipes_count = recipes.count
    recipes_titles = recipes[0..2].map { |recipe| recipe.title }
    text = recipes_titles.join(", ")
    text += t("cook_books.recipes_inside", count: recipes_count - 3) if recipes_count > 3
    recipes_count > 0 ? text : t("recipes.not_found")
  end

  def authorize_cook_book_dropdown?(cook_book)
    user_signed_in? && (cook_book.user == current_user || current_user.admin?)
  end
end
