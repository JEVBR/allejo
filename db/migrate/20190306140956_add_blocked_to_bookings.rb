class AddBlockedToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :blocked, :boolean, default: false
  end
end
