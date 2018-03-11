require 'date'
require_relative 'booking'
require_relative 'room'
require_relative 'invalid_duration_error'

module BookingSystem
  class Reservation < Booking
    attr_reader :room, :cost

    def initialize(input)
      super(input)
      @room = input[:room]
      @cost = input.has_key?(:rate) ? input[:rate] : @room.cost
    end

    def total_cost
      return booking_duration * @cost
    end

  end
end
