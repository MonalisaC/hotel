require 'csv'
require 'date'
require_relative 'room'
require_relative 'reservation'
require_relative 'block'
require_relative 'room_not_available_error'

module BookingSystem
  class Administrator
    attr_reader :rooms, :reservations, :range, :blocks

    def initialize
      @rooms = load_rooms
      #{}
      # (1..20).each{ |num| @rooms[num] = BookingSystem::Room.new(num, 200.00) }
      @reservations = {}
      @range = (1..500).to_a
      @blocks = {}
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
      raise ArgumentError.new("Incorrect room number") if !rooms.keys.include?(room_num)

      room = @rooms[room_num]
      raise RoomNotAvailableError.new("That room is not available")if !list_available_rooms(check_in, check_out).include?(room)

      reservation_details = {id: @range.shift, check_in: check_in, check_out: check_out, room: room}
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
        reserved_rooms += find_reservation(date).map{ |reservation| reservation.room }
      }
      return reserved_rooms.flatten.uniq
    end

    def list_blocked_rooms(start_date, end_date)
      blocked_rooms = []
      (start_date..end_date).each{ |date|
        selected_blocks = @blocks.select{|id, block|block.check_in <= date && block.check_out > date}.values
        blocked_rooms += selected_blocks.map{ |block| block.rooms }
      }
      return blocked_rooms.flatten.uniq
    end

    def list_available_rooms(start_date, end_date)
      return @rooms.values - list_reserved_rooms(start_date, end_date-1) - list_blocked_rooms(start_date, end_date-1)
    end

    def create_block(room_numbers, check_in, check_out, discounted_rate)
      raise ArgumentError.new("Room numbers should be an Array") if room_numbers.class != Array
      raise ArgumentError.new("Room count should be between 1 & 5") if room_numbers.count < 1 || room_numbers.count > 5

      block_rooms = []
      room_numbers.each { |room_num|
        raise ArgumentError.new("Incorrect room number #{room_num}") if !@rooms.keys.include?(room_num)
        raise RoomNotAvailableError.new("Room #{room_num} is not available") if !(list_available_rooms(check_in, check_out).map{|room|room.number}).include?(room_num)
        block_rooms << @rooms[room_num]
      }

      block_details = {id: @range.shift, check_in: check_in, check_out: check_out, rooms: block_rooms, rate: discounted_rate}
      new_block = BookingSystem::Block.new(block_details)
      @blocks[new_block.id] = new_block
      return new_block
    end

    def list_available_rooms_in_block(block_id)
      block = @blocks[block_id]
      return block.rooms - list_reserved_rooms(block.check_in, block.check_out - 1)
    end

    def reserve_in_block(block_id, room_number)
      block = @blocks[block_id]
      raise ArgumentError.new("Room #{room_number} not in block") if !block.rooms.map{ |room| room.number }.include?(room_number)
      room = @rooms[room_number]
      raise RoomNotAvailableError.new("That room is not available") if list_reserved_rooms(block.check_in, block.check_out - 1).include?(room)

      reservation_details = {id: @range.shift, check_in: block.check_in, check_out: block.check_out, room: room}
      new_reservation = BookingSystem::Reservation.new(reservation_details)
      @reservations[new_reservation.id] = new_reservation
      return new_reservation
    end

  end
end
