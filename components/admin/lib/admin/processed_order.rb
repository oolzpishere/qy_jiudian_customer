module Admin
  class ProcessedOrder

    attr_reader :order, :bed_obj, :nothing_obj

    def initialize(order: order)
      @order = order

      set_all_data
    end

    def set_all_data
      @bed_obj = Bed.new(order)
      @nothing_obj = Nothing.new(order)
    end

    def get_data(request)
      factory(order, request).data(request)
    end

    def factory(order, request, type: nil)
      # could give type, otherwise use request to factory.
      if type
        type_class = constantize("Admin::ProcessedOrder::#{type.camelize}")
        return type_class.new(order, request)
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
