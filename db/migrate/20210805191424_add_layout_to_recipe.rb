class AddLayoutToRecipe < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :layout, :integer, null: false, default: 0
  end
end
