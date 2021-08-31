class RemoveNullConstraintsRecipe < ActiveRecord::Migration[6.1]
  def change
    change_column_null :recipes, :preparation_description, true
    change_column_null :recipes, :time_in_minutes_needed, true
  end
end
