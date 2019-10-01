class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :group
      t.integer :count
      t.belongs_to :conference, index: true
      t.belongs_to :hotel, index: true
      t.string :room_type
      t.string :names
      t.string :contact
      t.string :phone
      # t.integer :room
      t.decimal :price
      t.integer :breakfast
      # t.integer :room_number
      t.date :checkin
      t.date :checkout
      t.integer :nights
      t.decimal :total_price

      t.timestamps
    end
  end
end
