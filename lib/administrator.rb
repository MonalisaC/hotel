require 'csv'
require 'date'
require_relative 'room'
require_relative 'reservation'
require_relative 'room_not_available_error'

module BookingSystem
  class Administrator
    attr_reader :rooms, :reservations, :range

    def initialize
      @rooms = load_rooms
      #{}
      # (1..20).each{ |num| @rooms[num] = BookingSystem::Room.new(num, 200.00) }
      @reservations = {}
      @range = (1..500).to_a
    end

    def load_rooms
      number = nil
      cost = nil
      rooms = {}
      CSV.read("support/rooms.csv", :headers => true, :header_converters => :symbol, :converters => :all).each { |line|
        number = line[0].to_i
        cost = line[1].to_f
        rooms[number] = BookingSystem::Room.new(number, cost)
      }
      return rooms
    end


    def list_rooms
      return @rooms.values
    end

    def reserve_room(room_num, check_in, check_out)
      raise ArgumentError.new("Incorrect room number")if room_num < 1 ||room_num > 20

      room = @rooms[room_num]
      reservation_details = {id: @range.shift, check_in: check_in, check_out: check_out, room: room}

      raise RoomNotAvailableError.new("That room is not available")if !list_available_rooms(check_in, check_out).include?(room)

      new_reservation = BookingSystem::Reservation.new(reservation_details)
      @reservations[new_reservation.id] = new_reservation
      return new_reservation
    end

    def find_reservation(date)
      return @reservations.select{|id, reservation|reservation.check_in <= date && reservation.check_out > date}.values
    end

    def total_cost(reservation_id)
      return @reservations[reservation_id].total_cost
    end

    def list_reserved_rooms(start_date, end_date)
      reserved_rooms = []
      (start_date..end_date).each{ |date|
      reserved_rooms += find_reservation(date).map{ |reservation| reservation.room }}
      return reserved_rooms.uniq
    end

    def list_available_rooms(start_date, end_date)
      return @rooms.values - list_reserved_rooms(start_date, end_date-1)
    end

  end
end
