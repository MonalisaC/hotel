require_relative 'spec_helper'

describe "Block class" do
  block_data = {
    id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-27"), rooms: [BookingSystem::Room.new(1, 200.00)], rate: 180.00 }

    let(:block) {BookingSystem::Block.new(block_data)}

    describe "#initialize" do
      it "raises an InvalidDurationError if Check out time is before check in time" do
        proc { BookingSystem::Block.new({id: 1, check_in: Date.parse("2018-03-20"), check_out: Date.parse("2018-03-15"), rooms: [BookingSystem::Room.new(1, 200.00)], rate: 180.00 })
      }.must_raise InvalidDurationError
    end

    it "is an instance of Block" do
      block.must_be_kind_of BookingSystem::Block
    end

    it "stores an array of rooms" do
      block.rooms.must_be_instance_of Array
      block.rooms.each { |room| room.must_be_kind_of BookingSystem::Room }
    end

    it "is set up for specific attributes and data types" do
      [:id, :check_in, :check_out, :rooms].each{|prop| block.must_respond_to prop}
      block.id.must_be_kind_of Integer
      block.check_in.must_be_kind_of Date
      block.check_out.must_be_kind_of Date
      block.rate.must_be_kind_of Numeric
    end
  end

  describe "#booking_duration" do
    it "returns the duration of the block in days" do
      block.booking_duration.must_equal 7
      block.booking_duration.must_be_instance_of Integer
    end
  end
end
