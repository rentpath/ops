require 'spec_helper'

describe Ops::Heartbeat do
  describe '#add' do
    it 'accepts new heartbeats' do
      @heartbeat = Ops::Heartbeat.new
      @heartbeat.add(:test) { true }
      expect(@heartbeat.heartbeats.size).to eq(1)
    end
  end

  describe '#check' do
    before do
      @heartbeat = Ops::Heartbeat.new
      @heartbeat.add(:test) { true }
    end

    it 'returns true for valid heartbeats' do
      expect(@heartbeat.check(:test)).to eq(true)
    end

    it 'returns false for invalid heartbeats' do
      expect(@heartbeat.check(:invalid_test)).to eq(false)
    end
  end

  describe '#heartbeats' do
    it 'returns a hash of heartbeats' do
      expect(Ops::Heartbeat.new.heartbeats).to be_a Hash
    end
  end

  it 'offers a singleton' do
    @heartbeat = Ops::Heartbeat.instance
    expect(@heartbeat.object_id).to be Ops::Heartbeat.instance.object_id
  end

  it "checks singleton's heartbeats" do
    Ops::Heartbeat.instance.add(:test) { true }
    expect(Ops::Heartbeat.check(:test)).to be true
  end
end

describe Ops do
  it 'provides convenience method to add heartbeats' do
    Ops.add_heartbeat(:convenience) { true }
    expect(Ops::Heartbeat.check(:convenience)).to be true
  end
end
