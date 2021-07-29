class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.bigint :follower_id, null: false, foreign_key: true
      t.bigint :followed_user_id, null: false, foreign_key: true

      t.timestamps
    end

    add_index :follows, :followed_user_id
    add_index :follows, [:follower_id, :followed_user_id], unique: true
  end
end
