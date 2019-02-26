class AddCoordinatesToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :latitude, :float
    add_column :pitches, :longitude, :float
  end
end
