class CreateHotelImages < ActiveRecord::Migration[5.2]
  def change
    create_table :hotel_images do |t|
      t.belongs_to :hotel, index: true
      t.integer :cover
      t.integer :position

      t.timestamps
    end
  end
end
