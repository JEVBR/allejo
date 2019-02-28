class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.references :friend
      t.references :user

      t.timestamps
    end

    add_foreign_key :friends, :users, column: :friend_id, primary_key: :id
  end
end
