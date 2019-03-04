class AddPlayerNameToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :player_name, :string
  end
end
