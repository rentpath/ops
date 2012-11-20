require 'spec_helper'

describe Ops::VERSION do
  it "returns a string with the version" do
    Ops::VERSION.should match /(\d+).(\d+).(\d+)([-+]([0-9A-Za-z-]+(.[0-9A-Za-z-]+)*)+)*/
  end
end
