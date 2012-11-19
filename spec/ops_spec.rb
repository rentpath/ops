require 'spec_helper'

describe Ops do

  before do
    Ops.instance_variables.each do |var|
      Ops.method(:remove_instance_variable).call(var)
    end
    Ops.stub(:file_root).and_return(File.dirname(__FILE__))
  end

  describe ".check_version" do
    it "should have version link" do
      Ops.stub(:app_name).and_return('App')
      Ops.stub(:version_or_branch).and_return('branch')
      version_page = Ops.check_version({})
      version_page.should have_tag('#version .label', 'App Version')
      version_page.should have_tag('#version .value a', 'branch')
    end

    it "should have date deployed" do
      Ops.stub(:deploy_date).and_return('now')
      version_page = Ops.check_version({})
      version_page.should have_tag('#date .label', 'Date Deployed')
      version_page.should have_tag('#date .value', 'now')
    end

    it "should have last commit" do
      Ops.stub(:last_commit).and_return('mock_sha')
      version_page = Ops.check_version({})
      version_page.should have_tag('#commit .label', 'Last Commit')
      version_page.should have_tag('#commit .value a', 'mock_sha')
    end

    it "should have host" do
      Ops.stub(:hostname).and_return('host')
      version_page = Ops.check_version({})
      version_page.should have_tag('#host .label', 'Host')
      version_page.should have_tag('#host .value', 'host')
    end

    it "should have headers" do
      Ops.stub(:headers).and_return({'header' => 'value'})
      version_page = Ops.check_version({})
      version_page.should have_tag('#headers .label', 'Headers')
      version_page.should have_tag('#headers .value td', 'header')
      version_page.should have_tag('#headers .value td', 'value')
    end

    it "should have environment" do
      Ops.stub(:environment).and_return('env')
      version_page = Ops.check_version({})
      version_page.should have_tag('#environment .label', 'Environment')
      version_page.should have_tag('#environment .value', 'env')
    end

    it "should render a valid html page" do
      version_page = Ops.check_version({})
      version_page.should have_tag('html')
      version_page.should have_tag('head')
      version_page.should have_tag('body')
    end

  end

  describe ".check_heartbeat" do

    it "should return 200 'OK' with no params" do
      heartbeat = Ops.check_heartbeat
      heartbeat[:status].should == 200
      heartbeat[:text].should == 'OK'
    end

    it "should return 200 '<name> is OK' with named heartbeat" do
      Ops.add_heartbeat(:foo) do
        "All is well"
      end
      heartbeat = Ops.check_heartbeat('foo')
      heartbeat[:status].should == 200
      heartbeat[:text].should == 'foo is OK'
    end

    it "should return 500 '<name> does not have a heartbeat' with invalid named heartbeat" do
      heartbeat = Ops.check_heartbeat('foo')
      heartbeat[:status].should == 500
      heartbeat[:text].should == 'foo does not have a heartbeat'
    end

    it "should return 500 '<name> does not have a heartbeat' if heartbeat fails" do
      Ops.add_heartbeat(:foo) do
        raise
      end
      heartbeat = Ops.check_heartbeat('foo')
      heartbeat[:status].should == 500
      heartbeat[:text].should == 'foo does not have a heartbeat'
    end

  end

  describe ".check_configuration" do
    it "should call current_config" do
      Ops.should_receive(:current_config).and_return({})
      Ops.check_configuration
    end

    it "should render a valid html page" do
      config_page = Ops.check_configuration
      config_page.should have_tag('html')
      config_page.should have_tag('head')
      config_page.should have_tag('body')
    end

    it "should have h2 for section" do
      Ops.add_configuration_section(:test){{}}
      config_page = Ops.check_configuration
      config_page.should have_tag('h2', 'test')
    end

    it "should have config section key and value in table" do
      Ops.add_configuration_section(:test){ { :some_key => 'the value' } }
      config_page = Ops.check_configuration
      config_page.should have_tag('.settings td.key', 'some_key')
      config_page.should have_tag('.settings td.value pre', '"the value"')
    end

  end

  describe '.add_configuration_section' do
    it "should add provided block to configuration hash" do
      config_block = lambda{}
      Ops.add_configuration_section(:test, &config_block)
      Ops.configuration.should have_key(:test)
      Ops.configuration[:test].should == config_block
    end

  end

  describe '.current_config' do
    it 'should call the configuration block' do
      config_block = lambda{}
      Ops.add_configuration_section(:test, &config_block)
      config_block.should_receive(:call).and_return( :key => 'value' )
      Ops.current_config
    end

    it 'should return empty hash if no config provided' do
      Ops.current_config.should == {}
    end
  end

  describe '.app_name' do

    it "should return config option if given" do
      Ops.app_name = 'Config App'
      Ops.app_name.should == 'Config App'
    end

    it "should return parent directory if not a timestamp" do
      Dir.stub(:pwd).and_return('/foo/bar')
      Ops.app_name.should == 'bar'
    end

    it "should return 2 levels up from parent if parent is timestamp (cap deploy structure)" do
      Dir.stub(:pwd).and_return('/app/releases/12345')
      Ops.app_name.should == 'app'
    end

    it "should strip '.com' off of parent name" do
      Dir.stub(:pwd).and_return('/app.com/releases/12345')
      Ops.app_name.should == 'app'
    end

  end

  describe '.version_or_branch' do
    it "should use contents of VERSION file if available" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(true)
      File.stub(:read).with(File.join(Ops.file_root, 'VERSION')).and_return('version')

      Ops.version_or_branch.should == 'version'
    end

    it "should use current git branch if in git repo and development mode" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(false)
      # stub on app instead of Kernel since apparently you can't stub on a Module
      Ops.stub(:`).with('git branch').and_return("* foo\n  bar")
      Ops.stub(:environment).and_return('development')

      Ops.version_or_branch.should == 'foo'
    end

    it "should be unknown if not in git repo" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(false)
      # stub on Ops instead of Kernel since apparently you can't stub on a Module
      Ops.stub(:`).with('git branch').and_return("fatal: Not a git repository (or any of the parent directories): .git")
      Ops.stub(:environment).and_return('development')

      Ops.version_or_branch.should match('^Unknown')
    end

    it "should be unknown if not in development mode" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(false)
      # stub on Ops instead of Kernel since apparently you can't stub on a Module
      Ops.stub(:`).with('git branch').and_return("* foo\n  bar")
      Ops.stub(:environment).and_return('production')

      Ops.version_or_branch.should match('^Unknown')
    end

  end

  describe '.deploy_date' do
    it "should use mtime of VERSION file if available" do
      time = mock('time')
      time.stub(:mtime).and_return('timestamp')
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(true)
      File.stub(:stat).with(File.join(Ops.file_root, 'VERSION')).and_return(time)

      Ops.deploy_date.should == 'timestamp'
    end

    it "should use 'Live' if in development" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(false)
      Ops.stub(:environment).and_return('development')

      Ops.deploy_date.should == 'Live'
    end

    it "should use unknown if not development" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'VERSION')).and_return(false)
      Ops.stub(:environment).and_return('production')

      Ops.deploy_date.should match('^Unknown')
    end
  end

  describe '.last_commit' do
    it "should use contents of REVISION file if available" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'REVISION')).and_return(true)
      File.stub(:read).with(File.join(Ops.file_root, 'REVISION')).and_return('some_sha')

      Ops.last_commit.should == 'some_sha'
    end

    it "should use current git HEAD if in git repo and development mode" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'REVISION')).and_return(false)
      Ops.stub(:`).with('git show').and_return("commit some_sha")
      Ops.stub(:environment).and_return('development')

      Ops.last_commit.should == 'some_sha'
    end

    it "should be unknown if not in git repo" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'REVISION')).and_return(false)
      Ops.stub(:`).with('git show').and_return("fatal: Not a git repository (or any of the parent directories): .git")
      Ops.stub(:environment).and_return('development')

      Ops.last_commit.should match('^Unknown')
    end

    it "should be unknown if not in development mode" do
      File.stub(:exists?).with(File.join(Ops.file_root, 'REVISION')).and_return(false)
      Ops.stub(:`).with('git show').and_return("commit some_sha")
      Ops.stub(:environment).and_return('production')

      Ops.last_commit.should match('^Unknown')
    end

  end

end
