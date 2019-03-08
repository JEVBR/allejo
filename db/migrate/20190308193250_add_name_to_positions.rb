class AddNameToPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :name, :string
  end
end
