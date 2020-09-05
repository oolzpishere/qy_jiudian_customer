module Admin
  class DateRoom

    attr_reader :rooms, :date, :changed
    # @params:
    # date_room_rec: date_room record
    def initialize(date_room_rec)
      @rooms ||= date_room_rec.rooms
      @date ||= date_room_rec.date
      @changed ||= false
    end


  end
end
