class AddPositionToRoomTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :room_types, :position, :integer
  end
end
