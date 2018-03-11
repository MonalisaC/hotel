require_relative 'spec_helper'

describe "Reservation class" do
  reservation_data = {
    id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), room: BookingSystem::Room.new(1, 200)}

    let(:reservation) {BookingSystem::Reservation.new(reservation_data)}

    describe "#initialize" do
      it "raises an InvalidDurationError if Check out time is before check in time" do
        proc { BookingSystem::Reservation.new({id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-15"), room: BookingSystem::Room.new(1, 200)})
      }.must_raise InvalidDurationError
    end

    it "is an instance of Reservation" do
      reservation.must_be_kind_of BookingSystem::Reservation
    end

    it "stores an instance of room" do
      reservation.room.must_be_kind_of BookingSystem::Room
    end

    it "is set up for specific attributes and data types" do
      [:id, :check_in, :check_out, :room].each{|prop| reservation.must_respond_to prop}

      reservation.id.must_be_kind_of Integer
      reservation.check_in.must_be_kind_of Date
      reservation.check_out.must_be_kind_of Date
    end
  end

  describe "#booking_duration" do
    it "returns the duration of the booking in days" do
      reservation.booking_duration.must_equal 7
      reservation.booking_duration.must_be_instance_of Integer
    end
  end

  describe "#total_cost" do
    it "returns total cost for a given reservation" do
      reservation.total_cost.must_equal 1400
      reservation.total_cost.must_be_instance_of Integer
    end

    it "does not charge for the checkout day" do
      reservation_for_2_days = BookingSystem::Reservation.new({
        id: 1, check_in: Date.parse("2018-03-01"), check_out: Date.parse("2018-03-02"), room: BookingSystem::Room.new(1, 200)})
      reservation_for_2_days.total_cost.must_equal 200
    end

    it "uses the rate if provided" do
      discounted_reservation = BookingSystem::Reservation.new({id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), room: BookingSystem::Room.new(1, 200), rate: 100.00})
      discounted_reservation.total_cost.must_equal 700.00
    end
  end


end
