class AddPlayerPhoneToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :player_phone, :string
  end
end
