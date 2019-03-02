class AddClosingTimeToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :closing_time, :datetime
  end
end
