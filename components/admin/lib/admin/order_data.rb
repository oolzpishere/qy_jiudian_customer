module Admin
  class OrderData
    # attr_accessor :twin_beds, :queen_bed, :three_beds, :other_twin_beds
    attr_reader :order, :i, :room, :room_type_translate, :hotel_room_type
    def initialize(params)
      @order = params[:order]
      @i = params[:i]
      @room = params[:room]
      @room_types_array = ["twin_beds", "queen_bed", "three_beds","other_twin_beds"]
      @room_type_translate = {"twin_beds" => "双人房","queen_bed" => "大床房", "three_beds" => "三人房","other_twin_beds" => "其它双人房" }
      @hotel_room_type = get_hotel_room_type(order)
    end

    def send_command(command)
      if self.try(command)
        self.send(command)
      elsif order.try(command)
        order.send(command)
      end
    end

    def get_hotel_room_type(order)
      room_type_id = order.hotel.room_types.find_by(name_eng: order.room_type).id
      order.hotel.hotel_room_types.find_by(room_type_id: room_type_id)
    end

    def conference_name
      order.conference.name
    end

    def hotel_name
      order.hotel.name
    end

    def id
      i + 1
    end

    def names
      room.names
    end

    def room_number
      room.room_number
    end

    def twin_beds
      hotel_room_type.room_type.name_eng.match(/twin_beds/) ? 1 : ""
    end

    def queen_bed
      hotel_room_type.room_type.name_eng.match(/queen_bed/) ? 1 : ""
    end

    def three_beds
      hotel_room_type.room_type.name_eng.match(/three_beds/) ? 1 : ""
    end

    def other_twin_beds
      hotel_room_type.room_type.name_eng.match(/other_twin_beds/) ? 1 : ""
    end

    def twin_beds_price
      hotel_room_type.room_type.name_eng.match(/twin_beds/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).price : ""
    end

    def queen_bed_price
      hotel_room_type.room_type.name_eng.match(/queen_bed/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).price : ""
    end

    def three_beds_price
      hotel_room_type.room_type.name_eng.match(/three_beds/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).price : ""
    end

    def other_twin_beds_price
      hotel_room_type.room_type.name_eng.match(/other_twin_beds/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).price : ""
    end

    def twin_beds_settlement_price
      hotel_room_type.room_type.name_eng.match(/twin_beds/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).settlement_price : ""
    end

    def queen_bed_settlement_price
      hotel_room_type.room_type.name_eng.match(/queen_bed/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).settlement_price : ""
    end

    def three_beds_settlement_price
      hotel_room_type.room_type.name_eng.match(/three_beds/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).settlement_price : ""
    end

    def other_twin_beds_settlement_price
      hotel_room_type.room_type.name_eng.match(/other_twin_beds/) ? order.hotel.hotel_room_types.find(hotel_room_type.id).settlement_price : ""
    end

    def check_in_out
      checkin = order.checkin
      checkout = order.checkout
      "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
    end

    def checkin_zh
      checkin = order.checkin
      "#{checkin.month}月#{checkin.day}日"
    end

    def checkout_zh
      checkout = order.checkout
      "#{checkout.month}月#{checkout.day}日"
    end

    def conference_period_zh
      start = order.conference.start
      finish = order.conference.finish
      "#{start.month}月#{start.day}日-#{finish.month}月#{finish.day}日"
    end

    def conference_check_in_out
      checkin = order.conference.sale_from
      checkout = order.conference.sale_to
      "#{checkin.month}月#{checkin.day}日-#{checkout.month}月#{checkout.day}日"
    end

    def nights
      (order.checkout-order.checkin).to_i
    end

    def breakfast
      order.breakfast.to_i == 1 ? "含早" : "不含早"
    end

    def breakfast_boolean
      order.breakfast.to_i == 1 ? "含" : "不含"
    end

    def all_names
      names = []
      order.rooms.each do |room|
        names += room.names.split(/,|、|，/)
      end
      names
    end

    def all_names_string
      all_names.join('、')
    end

    def peoples_count
      "#{all_names.count}人"
    end

    def room_type_zh
      hotel_room_type.room_type.name
    end

    def room_count_zh
      "#{order.rooms.count}间"
    end

    def settlement_price
      hotel_room_type.settlement_price
    end

    def price
      order.price
    end

    def price_zh
      "#{price}元/间/天"
    end

    def total_price
      # 单价 * 天数
      price * nights
    end

    def car
      order.hotel.car == 0 ? "不含用车" : "含用车"
    end

    def actual_settlement
      settlement_price * nights
    end

    def profit
      total_price - actual_settlement
    end

    def tax_rate
      order.hotel.tax_rate
    end

    def tax_point
      order.hotel.tax_point
    end

    def actual_profit
      profit - (profit * tax_rate)
    end

  end
end
