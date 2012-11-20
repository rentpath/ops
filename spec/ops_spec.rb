require 'spec_helper'

describe Ops do
  describe '#new' do
    it 'returns a new Ops::Server instance' do
      Ops.new.should be_a Sinatra::ExtendedRack
    end
  end
end
