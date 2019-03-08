class AddPositionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :position, foreign_key: true
  end
end
