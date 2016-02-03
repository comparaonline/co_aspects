require 'spec_helper'

describe CoAspects::Aspects::StatsIncrementAspect do
  before do
    stub_class('Name::Target') do
      aspects_annotations!
      def initialize
        @var = 'hello.world'
      end
      _stats_increment
      def perform_default_key
        :success
      end
      _stats_increment as: 'custom.key'
      def perform_only_as
        :success
      end
      _stats_increment { |arg| arg.to_s }
      def perform_only_block(arg)
        arg
      end
      _stats_increment { @var }
      def perform_block_scope
        :success
      end
      _stats_increment(as: 'CUSTOM.KEY.') { |arg| arg.to_s }
      def perform_dynamic_key(arg)
        arg
      end
    end
  end

  it 'stores the increment with the default key' do
    expect(StatsD).to receive(:increment)
      .with('name.target.perform_default_key')
    Name::Target.new.perform_default_key
  end

  it 'uses only the block if present' do
    expect(StatsD).to receive(:increment)
      .with('dynamic.key')
    Name::Target.new.perform_only_block('dynamic.key')
  end

  it 'can access instance variables via the block' do
    expect(StatsD).to receive(:increment)
      .with('hello.world')
    Name::Target.new.perform_block_scope
  end

  it 'uses only the alias if present' do
    expect(StatsD).to receive(:increment)
      .with('custom.key')
    Name::Target.new.perform_only_as
  end

  it 'uses both alias and block if both are present' do
    expect(StatsD).to receive(:increment)
      .with('custom.key.dynamic')
    Name::Target.new.perform_dynamic_key('dynamic')
  end

  it 'returns the correct value' do
    allow(StatsD).to receive(:increment)
    expect(Name::Target.new.perform_dynamic_key('dynamic')).to eq('dynamic')
  end
end
