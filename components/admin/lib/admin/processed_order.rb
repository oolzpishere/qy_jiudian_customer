require_relative 'processed_order/nothing'
require_relative 'processed_order/hotel'
require_relative 'processed_order/bed'
require_relative 'processed_order/calc'


module Admin
  class ProcessedOrder

    attr_reader :order, :bed_obj, :nothing_obj, :hotel_obj, :calc_obj

    def initialize(order: order)
      @order = order

      set_all_data
    end

    def set_all_data
      @bed_obj = Bed.new(order)
      @nothing_obj = Nothing.new(order)
      @hotel_obj = Hotel.new(order)
      @calc_obj = Calc.new(order, bed_obj: bed_obj)
    end

    def get_data(request: nil, type: nil)
      factory(order, request, type: type).data(request)
    end

    def factory(order, request, type: nil)
      # could give type, otherwise use request to factory.
      case type
      when /calc/
        return calc_obj
      when /hotel/
        return hotel_obj
      when /bed/
        return bed_obj
      end

      case request.to_s
      when /bed/
        bed_obj
      else
        nothing_obj
      end
    end

  end
end
