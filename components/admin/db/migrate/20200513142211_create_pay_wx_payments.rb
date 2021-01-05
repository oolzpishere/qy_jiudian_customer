class CreatePayWxPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :wx_payments do |t|
      t.belongs_to :payment, index: true

      # notify:
      t.string :appid
      t.string :mch_id
      t.string :device_info
      t.string :openid
      t.string :is_subscribe
      t.string :trade_type
      t.string :bank_type
      t.integer :total_fee
      t.integer :settlement_total_fee
      t.string :fee_type
      t.integer :cash_fee
      t.string :cash_fee_type
      # t.integer :coupon_fee
      # t.integer :coupon_count
      # t.string :coupon_type_$n
      # t.string :coupon_id_$n
      # t.integer :coupon_fee_$n
      t.string :transaction_id
      t.string :out_trade_no, index: true
      t.string :attach
      t.date :time_end


      t.timestamps
    end
  end
end
