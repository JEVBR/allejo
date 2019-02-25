class CreateDailySchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_schedules do |t|
      t.integer :time_slot
      t.references :pitch, foreign_key: true

      t.timestamps
    end
  end
end
