require 'spec_helper'

describe CoAspects::Aspects::LogCallAspect do
  before do
    stub_class('Target') do
      aspects_annotations!
      _log_call
      def log_when_called(arg1, arg2)
        'result'
      end
    end
    class_double('Rails').as_stubbed_const
    allow(Rails).to receive_message_chain(:logger, :debug)
  end

  it 'logs the method call with arguments' do
    expect(Rails).to receive_message_chain(:logger, :debug)
      .with(/log_when_called.*first.*second.*result/)
    Target.new.log_when_called('first', 'second')
  end

  it 'returns the correct result' do
    result = Target.new.log_when_called('first', 'second')
    expect(result).to eq('result')
  end
end
