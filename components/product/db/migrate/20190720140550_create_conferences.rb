class CreateConferences < ActiveRecord::Migration[5.2]
  def change
    create_table :conferences do |t|
      t.string :name
      t.date :start
      t.date :finish
      t.date :sale_from
      t.date :sale_to

      t.timestamps
    end
  end
end
