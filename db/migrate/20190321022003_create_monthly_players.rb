class CreateMonthlyPlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_players do |t|
      t.references :pitch, foreign_key: true
      t.integer :start_time
      t.integer :end_time
      t.string :day_of_the_week
      t.string :player_name
      t.string :player_phone
      t.string :player_email

      t.timestamps
    end
  end
end
