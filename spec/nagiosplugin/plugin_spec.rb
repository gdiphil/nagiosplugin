require 'spec_helper'

describe NagiosPlugin::Plugin do
  before do
    @plugin = NagiosPlugin::Plugin.new
  end

  describe '#run' do
    before do
      @plugin.stub(:puts)
      @plugin.stub(:exit)
    end

    it 'should run the check method' do
      @plugin.should_receive(:check).with(no_args)
      @plugin.run
    end

    context 'when check method is missing' do
      #it 'should output a hint for the developer' do
        #@plugin.should_receive(:puts).with(/unknown method check/)
        #@plugin.run
      #end

      it 'should exit unknown' do
        @plugin.should_receive(:exit).with(3)
        @plugin.run
      end
    end

    it 'should exit unknown when no status method was called' do
      @plugin.should_receive(:exit).with(3)
      def @plugin.check
        #...
      end
      @plugin.run
    end

    context 'when check raises a status error' do
      before do
        def @plugin.check
          raise NagiosPlugin::Plugin::StatusError.new(:foo, 42), 'hello, world.'
        end
      end

      it 'should output the status type' do
        @plugin.should_receive(:puts).with(/FOO/)
        @plugin.run
      end

      it 'should output the status message' do
        @plugin.should_receive(:puts).with(/hello, world\./)
        @plugin.run
      end

      it 'should exit with the exit status from status error' do
        @plugin.should_receive(:exit).with(42)
        @plugin.run
      end
    end
  end
end

#describe NagiosPlugin::Plugin::StatusError do
#  it 'shoud convert to 0 when ok' do
#    NagiosPlugin::Plugin::StatusError.new(:ok).to_i.should eql(0)
#  end
#end
