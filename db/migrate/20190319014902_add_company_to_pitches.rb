class AddCompanyToPitches < ActiveRecord::Migration[5.2]
  def change
    add_column :pitches, :company, :string
  end
end
