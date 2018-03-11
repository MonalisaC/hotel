require_relative 'spec_helper'

describe "Room class" do
  number = 1
  cost = 200
  let(:room) {BookingSystem::Room.new(number, cost)}

  describe "#initialize" do
    it "is an instance of Room" do
      room.must_be_kind_of BookingSystem::Room
    end
    it "is set up for specific attributes and data types" do
      [:number, :cost].each{|prop| room.must_respond_to prop}

      room.number.must_be_kind_of Integer
      room.cost.must_be_kind_of Integer
    end

  end
end
