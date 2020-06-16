class CreatePayPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.belongs_to :order, index: true

      t.timestamps
    end
  end
end
