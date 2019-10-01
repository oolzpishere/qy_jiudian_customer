class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.belongs_to :order, index: true
      t.string :names
      t.string :room_number

      t.timestamps
    end
  end
end
