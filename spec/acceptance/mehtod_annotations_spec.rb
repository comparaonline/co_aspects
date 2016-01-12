require 'spec_helper'

describe 'Annotations' do
  let(:target) { stub_class('Target') { extend CoAspects::Annotations } }

  context 'when the aspect does not exist' do
    it 'raises an error' do
      expect { target.class_eval { _none } }
        .to raise_error(CoAspects::AspectNotFoundError, /None.*_none/)
    end
  end

  context 'when the aspect exists' do
    let!(:sink_methods) do
      stub_class('CoAspects::SinkMethodsAspect') do
        class << self
          attr_accessor :calls
          def apply(_, options)
            (@calls ||= []) << options[:method]
          end
        end
      end
    end

    it 'applies the aspect to target methods only' do
      target.class_eval do
        _sink_methods; def target1; end
        _sink_methods; def target2; end
        def non_target; end
      end

      expect(CoAspects::SinkMethodsAspect.calls)
        .to contain_exactly(:target1, :target2)
    end

    it 'applies multiple aspects to the same method' do
      target.class_eval do
        _sink_methods; _sink_methods; def target1; end
        def non_target; end
      end

      expect(CoAspects::SinkMethodsAspect.calls)
        .to contain_exactly(:target1, :target1)
    end

    it 'does not explode when the aspect defines new methods' do
      stub_class 'CoAspects::OverflowAspect' do
        def self.apply(target, _)
          target.send(:define_method, :overflow) { }
        end
      end

      expect { target.class_eval { _overflow; def overflow; end } }
        .not_to raise_error
    end

    it 'pass arguments as options to the aspect' do
      stub_class 'CoAspects::OptionsAspect' do
        class << self
          attr_accessor :args
          def apply(_, options)
            @args = options[:args]
          end
        end
      end

      target.class_eval do
        _options 'name1', 'name2', op1: 'val1', op2: 'val2'; def target; end
      end

      expect(CoAspects::OptionsAspect.args)
        .to contain_exactly('name1', 'name2', {op1: 'val1', op2: 'val2'})
    end

    it 'pass the block as options to the aspect' do
      stub_class 'CoAspects::BlockAspect' do
        class << self
          attr_accessor :block
          def apply(_, options)
            @block = options[:block].call('called')
          end
        end
      end

      target.class_eval do
        _block { |arg| arg }; def target; end
      end

      expect(CoAspects::BlockAspect.block).to eq('called')
    end
  end

  def stub_class(name, &block)
    stub_const name, Class.new
    name.constantize.class_eval(&block)
  end
end
