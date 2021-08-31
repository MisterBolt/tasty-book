class CreateSections < ActiveRecord::Migration[6.1]
  class Recipe < ApplicationRecord; end
  class Section < ApplicationRecord; end

  def up
    create_table :sections do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.belongs_to :recipe

      t.timestamps
    end

    Recipe.find_each do |recipe|
      Section.create!(recipe_id: recipe.id, title: "Description", body: recipe.preparation_description)
    end

    remove_column :recipes, :preparation_description, :text
  end

  def down
    add_column :recipes, :preparation_description, :text

    Recipe.find_each do |recipe|
      recipe.update!(preparation_description: Section.where(recipe_id: recipe.id).pluck(:description).join)
    end

    drop_table :sections
  end
end