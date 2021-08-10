class CreateJoinTableCategoryRecipe < ActiveRecord::Migration[6.1]
  def change
    create_join_table :categories, :recipes do |t|
      t.index [:category_id, :recipe_id], unique: true
    end
  end
end
