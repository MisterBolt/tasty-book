class RemoveIndexFromRecipeScores < ActiveRecord::Migration[6.1]
  def change
    remove_index :recipe_scores, name: "index_recipe_scores_on_user_id"
  end
end
