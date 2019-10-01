class CreateDateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :date_rooms do |t|
      t.belongs_to :hotel_room_type, index: true
      t.date :date
      t.integer :rooms

      t.timestamps
    end
  end
end
