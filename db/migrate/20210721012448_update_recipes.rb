class UpdateRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :user_id, :bigint, null: false, foreign_key: true
    add_index :recipes, :user_id
  end
end
