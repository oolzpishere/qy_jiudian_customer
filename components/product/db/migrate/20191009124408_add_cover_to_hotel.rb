class AddCoverToHotel < ActiveRecord::Migration[5.2]
  def change
    add_column :hotels, :cover, :string
    add_column :hotels, :distance, :string
    add_column :hotels, :address, :string
  end
end
