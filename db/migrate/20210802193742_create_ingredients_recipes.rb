class CreateIngredientsRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients_recipes do |t|
      t.references :recipe, index: true, foreign_key: true, null: false
      t.references :ingredient, index: true, foreign_key: true, null: false
      t.integer :quantity, null: false
      t.integer :unit, null: false, default: 0

      t.timestamps
    end
  end
end
