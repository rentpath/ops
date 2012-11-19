require 'spec_helper'

describe Ops::Revision do

  before do
    @root = File.dirname(__FILE__)
    @version_file = File.join(@root, 'VERSION')
    settings = double("settings", {:file_root => @root, :environment => 'test'})
    File.open(@version_file, 'w') { |f| f.write('v23.24.25^{}') }
    headers = {}
    @version = Ops::Revision.new(headers, settings)
  end

  after do
    File.delete(@version_file)
  end

  it "should have version" do
    @version.version_or_branch.should eq("v23.24.25")
  end

end