class CreateHotels < ActiveRecord::Migration[5.2]
  def change
    create_table :hotels do |t|
      t.string :name, null: false

      t.integer :breakfast, default: 0
      t.integer :car, default: 0
      t.decimal :tax_rate, default: 0
      t.decimal :tax_point, default: 0

      t.timestamps
    end
  end
end
