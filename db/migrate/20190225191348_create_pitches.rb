class CreatePitches < ActiveRecord::Migration[5.2]
  def change
    create_table :pitches do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.string :subtitle
      t.string :address
      t.string :cep
      t.string :cnpj

      t.timestamps
    end
  end
end
