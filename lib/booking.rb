require 'date'
require_relative 'invalid_duration_error'

module BookingSystem
  class Booking
    attr_reader :id, :check_in, :check_out

    def initialize(input)
      @id = input[:id]
      @check_in = input[:check_in]
      @check_out = input[:check_out]
      raise InvalidDurationError.new("Check out time can not be before check in time") if booking_duration < 0
    end

    def booking_duration
      return (@check_out - @check_in).to_i
    end

  end
end
