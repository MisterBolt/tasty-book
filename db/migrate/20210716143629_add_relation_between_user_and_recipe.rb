class AddRelationBetweenUserAndRecipe < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :user_id, :bigint, null: false, foreign_key: true
  end
end
