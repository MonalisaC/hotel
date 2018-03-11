require 'date'
require_relative 'booking'
require_relative 'invalid_duration_error'

module BookingSystem
  class Block < Booking
    attr_reader :rooms, :rate

    def initialize(input)
      super(input)
      @rooms = input[:rooms]
      @rate = input[:rate]
    end

  end
end
