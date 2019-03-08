class AddPhoneToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :phone, :string
  end
end
