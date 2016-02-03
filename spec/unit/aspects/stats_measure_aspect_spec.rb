require 'spec_helper'

describe CoAspects::Aspects::StatsMeasureAspect do
  before do
    stub_class('Name::Target') do
      def initialize
        @var = 'hello.world'
      end
      aspects_annotations!
      _stats_measure
      def perform_default_key
        :success
      end
      _stats_measure as: 'custom.key'
      def perform_only_as
        :success
      end
      _stats_measure { |arg| arg.to_s }
      def perform_only_block(arg)
        arg
      end
      _stats_measure { @var }
      def perform_block_scope
        :success
      end
      _stats_measure(as: 'CUSTOM.KEY.') { |arg| arg.to_s }
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

  it 'uses only the block if present' do
    expect(StatsD).to receive(:measure) { |_, &block| block.call }
      .with('dynamic.key')
    Name::Target.new.perform_only_block('dynamic.key')
  end

  it 'can access instance variables via the block' do
    expect(StatsD).to receive(:measure) { |_, &block| block.call }
      .with('hello.world')
    Name::Target.new.perform_block_scope
  end

  it 'uses only the alias if present' do
    expect(StatsD).to receive(:measure) { |_, &block| block.call }
      .with('custom.key')
    Name::Target.new.perform_only_as
  end

  it 'uses both alias and block if both are present' do
    expect(StatsD).to receive(:measure) { |_, &block| block.call }
      .with('custom.key.dynamic')
    Name::Target.new.perform_dynamic_key('dynamic')
  end

  it 'returns the correct value' do
    allow(StatsD).to receive(:measure) { |_, &block| block.call }
    expect(Name::Target.new.perform_dynamic_key('dynamic')).to eq('dynamic')
  end
end
