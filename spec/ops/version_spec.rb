require 'spec_helper'

RSpec.describe Ops::VERSION do
  it 'returns a string with the version' do
    expect(Ops::VERSION).to match /(\d+).(\d+).(\d+)([-+]([0-9A-Za-z-]+(.[0-9A-Za-z-]+)*)+)*/
  end
end
