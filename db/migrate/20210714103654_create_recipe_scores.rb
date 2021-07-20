class CreateRecipeScores < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_scores do |t|
      t.bigint :user_id, null: false, foreign_key: true
      t.bigint :recipe_id, null: false, foreign_key: true
      t.integer :score, null: false

      t.timestamps
    end
    add_index :recipe_scores, :recipe_id
    add_index :recipe_scores, [:user_id, :recipe_id], unique: true
  end
end
