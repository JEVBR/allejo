class AddDescriptionToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :description, :text
  end
end
