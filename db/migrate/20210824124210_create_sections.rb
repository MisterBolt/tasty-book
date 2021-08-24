class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.belongs_to :recipe

      t.timestamps
    end

    remove_column :recipes, :preparation_description, :text
  end
end
