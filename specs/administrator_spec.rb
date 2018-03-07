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
      # it "raises an error if room is not available" do
      #   admin.reserve_room(5, Date.parse('2018-03-27'), Date.parse('2018-03-30'))
      #   proc { !list_available_rooms(Date.parse('2018-03-27'), Date.parse('2018-03-30')).include?(@rooms[5])
      #   }.must_raise RoomNotAvailableError
      # end
      # it "can reserve a room for a given date range" do
      #   admin.reserve_room(1, Date.parse("2018-03-20"), Date.parse("2018-03-27")).must_be_instance_of Reservation
      # end
    end

    describe "#find_reservation" do
      reservation_data = {
        id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), room: BookingSystem::Room.new(1, 200)}

        let(:reservation) {BookingSystem::Reservation.new(reservation_data)}

        it "can access the list of reservations for a specific date" do
          admin.find_reservation('2018-03-27').must_be_instance_of Array
          # admin.find_reservation('2018-03-27')[0].must_be_kind_of BookingSystem::Reservation
        end
      end

      describe "#total_cost" do
        reservation_data = {
          id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), room: BookingSystem::Room.new(1, 200)}

          let(:reservation) {BookingSystem::Reservation.new(reservation_data)}

        it "can get the total cost for a given reservation" do
          skip
          # admin.total_cost(1).must_equal 1400
        end
      end

      describe "list_reserved_rooms" do
        it "can view a list of rooms that are reserved for a given date range" do
          admin.list_reserved_rooms.must_be_instance_of Array
        end
      end

      describe "list_available_rooms" do
        it "can view a list of rooms that are not reserved for a given date range" do
          admin.list_available_rooms.must_be_instance_of Array
        end
      end

    end
