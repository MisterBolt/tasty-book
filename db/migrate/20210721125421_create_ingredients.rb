class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :ingredients, :name, unique: true
  end
end
