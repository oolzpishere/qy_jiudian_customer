module Product
  class Order < ApplicationRecord
    self.table_name = :orders

    validates :group, presence: true

    belongs_to :conference
    belongs_to :hotel

    has_many :rooms, dependent: :destroy
    accepts_nested_attributes_for :rooms, allow_destroy: true, reject_if: :all_blank

    # def checkin_zh
    #   checkin = self.checkin
    #   "#{checkin.month}月#{checkin.day}日"
    # end
    #
    # def checkout_zh
    #   checkout = self.checkout
    #   "#{checkout.month}月#{checkout.day}日"
    # end
    #
    # def check_in_out
    #   checkin = self.checkin
    #   checkout = self.checkout
    #   "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
    # end
    #
    # def nights
    #   (self.checkout-self.checkin).to_i
    # end

  end
end
