class AddOpeningTimeToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :opening_time, :integer
  end
end
