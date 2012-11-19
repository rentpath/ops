require 'spec_helper'

describe Ops::Revision do

  let(:create_version_file) do
    @version_file = File.join(@root, 'VERSION')
    File.open(@version_file, 'w') { |f| f.write('v23.24.25^{}') }
  end

  before do
    @root = File.dirname(__FILE__)
    headers = {}
    settings = double("settings", {:file_root => @root, :environment => 'test'})
    @version = Ops::Revision.new(headers, settings)
  end

  after do
    File.delete(@version_file) unless @version_file.nil?
  end

  it "test env should have version" do
    create_version_file
    @version.version_or_branch.should eq("v23.24.25")
  end

  it "development env should have branch" do
    dev_settings = double("settings", {:file_root => @root, :environment => 'development'})
    dev_version = Ops::Revision.new({}, dev_settings)
    dev_version.version_or_branch.should eq("master")
  end

  it "should have request headers" do
    headers = {'ABC' => '123', 'hidden' => 'x'}
    settings = double("settings", {:file_root => @root, :environment => 'test'})
    version = Ops::Revision.new(headers, settings)
    version.headers.should eq({'ABC' => '123'})
  end


end