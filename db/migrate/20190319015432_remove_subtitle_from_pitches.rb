class RemoveSubtitleFromPitches < ActiveRecord::Migration[5.2]
  def change
    remove_column :pitches, :subtitle
  end
end
