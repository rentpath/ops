require 'spec_helper'

describe Ops::Revision do

  before do
    root = File.dirname(__FILE__)
    settings = double("settings", {:file_root => root, :environment => 'test'})
    File.open(File.join(root, 'VERSION'), 'w') do |f|
      f.write('v23.24.25^{}')
    end
    headers = {}
    @version = Ops::Revision.new(headers, settings)
  end

  it "should have version" do
    @version.version_or_branch.should eq("v23.24.25")
  end

end