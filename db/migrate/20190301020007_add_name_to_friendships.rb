class AddNameToFriendships < ActiveRecord::Migration[5.2]
  def change
    add_column :friendships, :name, :string
  end
end
