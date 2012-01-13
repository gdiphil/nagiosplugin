require "spec_helper"

describe NagiosPlugin::Plugin do
  before :each do
    @plugin = NagiosPlugin::Plugin.new
  end
  
  it "should be unknown when not checked yet" do
    @plugin.status.should eql(:unknown)
  end
  
  [
    {:critical? => false, :warning? => false, :status => :ok      },
    {:critical? => false, :warning? => true,  :status => :warning },
    {:critical? => true,  :warning? => false, :status => :critical},
    {:critical? => true,  :warning? => true,  :status => :critical}
  ].each do |result|
    it "should be #{result[:status].to_s} if checked so" do
      @plugin.stub(:critical?).and_return(result[:critical?])
      @plugin.stub(:warning?).and_return(result[:warning?])
      @plugin.check
      @plugin.status.should eql(result[:status])
    end
  end
  
  it "should raise when all checks return false" do
    [:critical?, :warning?, :ok?].each do |m|
      @plugin.stub(m).and_return(false)
    end
    lambda { @plugin.check }.should raise_error(NagiosPlugin::PluginError)
    @plugin.status.should eql(:unknown)
  end
  

  it "should raise if check methods are undefined" do
    lambda { @plugin.check }.should raise_error(NoMethodError)
    @plugin.status.should eql(:unknown)
    
    @plugin.instance_exec { def critical?; false end }
    lambda { @plugin.check }.should raise_error(NoMethodError)
    @plugin.status.should eql(:unknown)
    
    @plugin.instance_exec { def warning?; false end }
    lambda { @plugin.check }.should_not raise_error(NoMethodError)
    @plugin.status.should_not eql(:unknown)
  end
  
  it "should also represent the status as exit code" do
    {
      :ok => 0,
      :warning => 1,
      :critical => 2,
      :unknown => 3
    }.each_pair do |status,code|
      @plugin.stub(:status).and_return(status)
      @plugin.code.should eql(code)
    end
  end
  
  it "should alias to_s to message" do
    def @plugin.output; "hello, world" end
    @plugin.to_s.should eql(@plugin.message)
  end
  
  it "should alias to_i to code" do
    @plugin.to_i.should eql(@plugin.code)
  end
end
