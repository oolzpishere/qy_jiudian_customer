module Admin
  class Payment < ApplicationRecord
    self.table_name = 'payments'

    has_one :wx_payment
  end
end
