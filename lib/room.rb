module BookingSystem
  class Room
    attr_reader :number, :cost

    def initialize number, cost
      @number = number
      @cost = cost
    end
  end
end
