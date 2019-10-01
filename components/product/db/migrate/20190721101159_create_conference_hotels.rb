class CreateConferenceHotels < ActiveRecord::Migration[5.2]
  def change
    create_join_table :conferences, :hotels
  end
end
