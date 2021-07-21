class UpdateRecipe < ActiveRecord::Migration[6.1]
  def change
    remove_column :recipes, :description
    add_column :recipes, :how_to_prepare, :string
    add_column :recipes, :difficulty_id, :integer
    add_column :recipes, :time_needed, :integer
  end
end
