class AddMonthlyPlayerToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :monthly_player, foreign_key: true
  end
end
