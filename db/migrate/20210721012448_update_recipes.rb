class UpdateRecipes < ActiveRecord::Migration[6.1]
  def change
    add_index :recipes, :user_id
  end
end
