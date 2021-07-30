class CreateCookBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :cook_books do |t|
      t.bigint :user_id, null: false, foreign_key: true
      t.text :title, null: false
      t.integer :visibility, null: false
      t.boolean :favourite, null: false, default: false
      t.index :user_id

      t.timestamps
    end
  end
end
