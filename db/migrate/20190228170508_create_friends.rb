class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.references :user
      t.integer :friend_id, index: true

      t.timestamps
    end

    add_foreign_key :friends, :users, column: :friend_id
  end
end
