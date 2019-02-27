class AddPhotoToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :photo, :string
  end
end
