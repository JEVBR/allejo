class AddMatchDayMailerJobIdToBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :match_day_mailer_job_id, :string
  end
end
