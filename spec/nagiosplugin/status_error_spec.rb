require 'spec_helper'

describe NagiosPlugin::StatusError do
  def create_status(status, msg = '')
    NagiosPlugin::StatusError.new(status, msg)
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
