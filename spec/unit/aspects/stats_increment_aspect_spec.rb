require 'spec_helper'

describe CoAspects::Aspects::StatsIncrementAspect do
  before do
    stub_class('Name::Target') do
      aspects_annotations!
      _stats_increment
      def perform_default_key
        :success
      end
      _stats_increment(as: 'custom.key') { |arg| arg.to_s }
      def perform_dynamic_key(arg)
        arg
      end
    end
  end

  it 'stores the increment on StatsD' do
    expect(StatsD).to receive(:increment)
      .with('name.target.perform_default_key')
    Name::Target.new.perform_default_key
  end

  it 'builds a dynamic key if given' do
    expect(StatsD).to receive(:increment)
      .with('custom.key.dynamic')
    Name::Target.new.perform_dynamic_key('dynamic')
  end
end
