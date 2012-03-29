require 'spec_helper'

describe NagiosPlugin::Plugin do
  before do
    class MyPlugin < NagiosPlugin::Plugin; end
    @plugin = MyPlugin.new
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

    it 'should output the class name' do
      def @plugin.check; end
      @plugin.should_receive(:puts).with(/MYPLUGIN/)
      @plugin.run
    end

    context 'when an unknown exception was raised' do
      before do
        StandardError.any_instance.stub(:backtrace).and_return(%w[foo bar baz])
        def @plugin.check
          raise StandardError, 'Oops!'
        end
      end

      it 'should output the execptions message' do
        @plugin.should_receive(:puts).with(/Oops!/)
        @plugin.run
      end

      it 'should output the exceptions backtrace' do
        @plugin.should_receive(:puts).with(/foo\nbar\nbaz/)
        @plugin.run
      end

      it 'should exit unknown' do
        @plugin.should_receive(:exit).with(3)
        @plugin.run
      end
    end

    context 'when no exception was raised' do
      before { def @plugin.check; end }

      it 'should display a hint for the developer' do
        @plugin.should_receive(:puts).with(/no status method was called/i)
        @plugin.run
      end

      it 'should exit unknown' do
        @plugin.should_receive(:exit).with(3)
        @plugin.run
      end
    end

    context 'when a status error was raised' do
      before do
        def @plugin.check
          raise NagiosPlugin::Plugin::StatusError.new(:ok, 'hello, world.')
        end
      end

      it 'should output the status type' do
        @plugin.should_receive(:puts).with(/OK/)
        @plugin.run
      end

      it 'should output the status message' do
        @plugin.should_receive(:puts).with(/hello, world\./)
        @plugin.run
      end

      it 'should exit with the exit status from status error' do
        @plugin.should_receive(:exit).with(0)
        @plugin.run
      end
    end
  end
end


describe NagiosPlugin::Plugin::StatusError do
  def create_status(status, msg = '')
    NagiosPlugin::Plugin::StatusError.new(status, msg)
  end

  %w[ok warning critical unknown].each_with_index do |s,i|
    context "when #{s}" do
      before { @status = create_status(s.to_sym) }

      it 'should include status in the exception message' do
        @status.to_s.should include(s.upcase)
      end

      it "should convert to #{i}" do
        @status.to_i.should eql(i)
      end
    end
  end

  context 'when initialized with invalid status' do
    before { @status = create_status(:invalid) }

    it 'should include unknown status in the exception message' do
      @status.to_s.should include('UNKNOWN')
    end

    it 'should convert to 3' do
      @status.to_i.should eql(3)
    end
  end
end
