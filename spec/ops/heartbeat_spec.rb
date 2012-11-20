require 'spec_helper'

describe Ops::Heartbeat do
  it 'accepts new heartbeats' do
    @heartbeat = Ops::Heartbeat.new
    @heartbeat.add(:test){ true }
    @heartbeat.heartbeats.should have(1).items
  end

  describe '#check' do
    before do
      @heartbeat = Ops::Heartbeat.new
      @heartbeat.add(:test){ true }
    end

    it 'returns true for valid heartbeats' do
      @heartbeat.check(:test).should eq(true)
    end

    it 'returns false for invalid heartbeats' do
      @heartbeat.check(:invalid_test).should eq(false)
    end
  end

  it "offers a singleton" do
    @heartbeat = Ops::Heartbeat.instance
    @heartbeat.object_id.should be Ops::Heartbeat.instance.object_id
  end

  it "checks singleton's heartbeats" do
    Ops::Heartbeat.instance.add(:test){ true }
    Ops::Heartbeat.check(:test).should be true
  end

  it "provides convenience Ops method to add heartbeats" do
    Ops.add_heartbeat(:convenience){ true }
    Ops::Heartbeat.check(:convenience).should be true
  end
end
