class AddPhoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone, :integer, limit: 8
  end
end
