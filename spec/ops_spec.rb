require 'spec_helper'

RSpec.describe Ops do
  include Ops

  describe '#new' do
    subject { described_class.new }

    it 'returns a new Ops::Server instance' do
      expect(subject).to be_an_instance_of(Sinatra::Wrapper)
      expect(subject.inspect).to include('Ops::Server')
    end
  end
end
