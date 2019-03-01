class AddConfirmToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :confirm, :boolean, default: false
  end
end
