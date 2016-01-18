require 'spec_helper'

describe CoAspects::Aspects::StatsMeasureAspect do
  before do
    stub_class('Name::Target') do
      aspects_annotations!
      _stats_measure
      def perform_default_key
        :success
      end
      _stats_measure(as: 'CUSTOM.KEY') { |arg| arg.to_s }
      def perform_dynamic_key(arg)
        arg
      end
    end
  end

  it 'stores the measurement on StatsD' do
    expect(StatsD).to receive(:measure) { |_, &block| block.call }
      .with('name.target.perform_default_key')
    Name::Target.new.perform_default_key
  end

  it 'builds a dynamic key if given' do
    expect(StatsD).to receive(:measure) { |_, &block| block.call }
      .with('custom.key.dynamic')
    Name::Target.new.perform_dynamic_key('dynamic')
  end

  it 'returns the correct value' do
    allow(StatsD).to receive(:measure) { |_, &block| block.call }
    expect(Name::Target.new.perform_dynamic_key('dynamic')).to eq('dynamic')
  end
end
