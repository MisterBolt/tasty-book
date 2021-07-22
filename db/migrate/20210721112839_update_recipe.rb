class UpdateRecipe < ActiveRecord::Migration[6.1]
  def change
    remove_column :recipes, :description, :string
    add_column :recipes, :how_to_prepare, :string, null: false
    add_column :recipes, :difficulty_id, :integer, null: false
    add_column :recipes, :time_needed, :integer, null: false
  end
end
