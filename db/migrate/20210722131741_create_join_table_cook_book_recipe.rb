class CreateJoinTableCookBookRecipe < ActiveRecord::Migration[6.1]
  def change
    create_join_table :cook_books, :recipes do |t|
      t.index [:cook_book_id, :recipe_id]
      t.index [:recipe_id, :cook_book_id]
    end
  end
end
