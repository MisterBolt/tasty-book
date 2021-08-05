class UpdateRecipe < ActiveRecord::Migration[6.1]
  def change
    rename_column :recipes, :description, :preparation_description
    change_column :recipes, :preparation_description, :text, null: false
    add_column :recipes, :difficulty, :integer, null: false, default: 0
    add_column :recipes, :time_in_minutes_needed, :integer, null: false
  end
end
