require_relative 'spec_helper'
describe "Administrator class" do
  let(:admin){BookingSystem::Administrator.new}

  describe "#Initializer" do
    it "is an instance of Administrator" do
      admin.must_be_kind_of BookingSystem::Administrator
    end

    it "establishes the base data structures when instantiated" do
      [:rooms, :reservations, :range].each do |prop|
        admin.must_respond_to prop
      end

      admin.rooms.must_be_kind_of Hash
      admin.reservations.must_be_kind_of Hash
      admin.range.must_be_kind_of Array
    end
  end

  describe "#list_rooms" do
    it "can access the list of all of the rooms in the hotel" do
      admin.list_rooms.must_be_instance_of Array
      admin.list_rooms.each{|room| room.must_be_instance_of BookingSystem::Room}
    end
  end

  describe "#reserve_room" do
    reservation_data = {
      id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), room: BookingSystem::Room.new(1, 200)}

      let(:reservation) {BookingSystem::Reservation.new(reservation_data)}
      it "raises an error for Incorrect room number" do
        proc { admin.reserve_room(21, Date.parse('2018-03-27'), Date.parse('2018-03-30'))
        }.must_raise ArgumentError

        proc { admin.reserve_room(0, Date.parse('2018-03-27'), Date.parse('2018-03-30'))
        }.must_raise ArgumentError

        proc { admin.reserve_room("7", Date.parse('2018-03-27'), Date.parse('2018-03-30'))
        }.must_raise ArgumentError
      end
      it "raises an error if room is not available" do
        admin.reserve_room(5, Date.parse('2018-03-27'), Date.parse('2018-03-30'))
        proc { admin.reserve_room(5, Date.parse('2018-03-29'), Date.parse('2018-03-30'))}.must_raise RoomNotAvailableError
      end

      it "allows start on the same day that another reservation for the same room ends" do
        admin.reserve_room(5, Date.parse('2018-03-27'), Date.parse('2018-03-30'))
        admin.reserve_room(5, Date.parse('2018-03-23'), Date.parse('2018-03-27')).must_be_instance_of BookingSystem::Reservation
        admin.reserve_room(5, Date.parse('2018-03-30'), Date.parse('2018-04-01')).must_be_instance_of BookingSystem::Reservation
      end

      it "can reserve a room for a given date range" do
        admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-27")).must_be_instance_of BookingSystem::Reservation
      end

      it "adds to the reservations" do
        before = admin.reservations.count
        admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-27"))
        admin.reservations.count.must_equal before + 1
      end

      it "raises an error if all rooms are booked" do
        (1..20).each{ |num| admin.reserve_room(num, Date.parse('2018-03-27'), Date.parse('2018-03-30')) }
        proc { admin.reserve_room(5, Date.parse('2018-03-29'), Date.parse('2018-03-30'))}.must_raise RoomNotAvailableError
      end

    end

    describe "#find_reservation" do
      reservation_data = {
        id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), room: BookingSystem::Room.new(1, 200)}

        let(:reservation) {BookingSystem::Reservation.new(reservation_data)}

        it "can access the list of reservations for a specific date" do
          admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-27"))
          admin.find_reservation(Date.parse("2018-03-20")).must_be_instance_of Array
          admin.find_reservation(Date.parse("2018-03-20"))[0].must_be_kind_of BookingSystem::Reservation
        end

        it "returns an empty array when there are no reservations" do
          admin.find_reservation(Date.parse("2018-03-20")).must_be_instance_of Array
          admin.find_reservation(Date.parse("2018-03-20")).must_be_empty
        end
      end

      describe "#total_cost" do

        it "can get the total cost for a given reservation" do
          new_reservation = admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-27"))
          admin.total_cost(new_reservation.id).must_equal 1400.00
        end
      end

      describe "list_reserved_rooms" do
        it "can view a list of rooms that are reserved for a given date range" do
          admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-25"))
          admin.list_reserved_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25")).must_be_instance_of Array
          admin.list_reserved_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25")).count.must_equal 1
        end
        it "can view multiple rooms that are reserved for a given date range" do
          admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-25"))
          admin.reserve_room(2, Date.parse("2018-03-20"), Date.parse("2018-03-25"))
          admin.reserve_room(3, Date.parse("2018-03-20"), Date.parse("2018-03-25"))
          admin.list_reserved_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25")).must_be_instance_of Array
          admin.list_reserved_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25")).count.must_equal 3
        end
      end

      describe "list_available_rooms" do
        it "can view a list of rooms that are not reserved for a given date range" do
          admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-25"))
          admin.list_available_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25")).must_be_instance_of Array
          admin.list_available_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25")).count.must_equal 19
        end

        it "returns all rooms when none is reserved" do
          rooms = admin.list_available_rooms(Date.parse("2018-03-20"), Date.parse("2018-03-25"))
          rooms.count.must_equal 20
          rooms.map{|room| room.number}.sort.must_equal (1..20).to_a
        end
        it "returns empty when all are reserved" do
          20.times{ |index| admin.reserve_room(index+1, Date.parse('2018-03-27'), Date.parse('2018-03-30')) }
          admin.list_available_rooms(Date.parse("2018-03-27"), Date.parse("2018-03-30")).must_be_empty
        end
      end
    end
