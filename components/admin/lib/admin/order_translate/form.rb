module Admin
  module OrderTranslate
    class Form < Base

      def breakfast
        order.breakfast.to_i == 1 ? "含早" : "不含早"
      end



    end
  end
end
