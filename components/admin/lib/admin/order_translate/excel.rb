module Admin
  module OrderTranslate
    class Excel < Base

      def breakfast
        order.breakfast.to_i == 1 ? "含早" : "不含早"
      end



    end
  end
end
