class AddConfirmedToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :confirmed, :boolean, default: false
  end
end
