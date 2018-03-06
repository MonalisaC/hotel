require 'date'
require_relative 'invalid_duration_error'

module BookingSystem
  class Reservation
    attr_reader :id, :check_in, :check_out, :room

    def initialize(input)
      @id = input[:id]
      @check_in = input[:check_in]
      @check_out = input[:check_out]
      @room = input[:room]
      raise InvalidDurationError.new("Check out time can not be before check in time") if  booking_duration < 0
    end
# @check_out != nil &&
    def booking_duration
      # return nil if @check_out == nil
      return (@check_out - @check_in).to_i
    end

    def total_cost
      return booking_duration * @room.cost
    end

  end
end
