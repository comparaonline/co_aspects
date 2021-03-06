require 'spec_helper'

describe 'Annotations' do
  let(:target) { stub_class('Target') { aspects_annotations! } }

  context 'when the aspect does not exist' do
    it 'raises an error' do
      expect { target.class_eval { _none } }
        .to raise_error(CoAspects::AspectNotFoundError, /None.*_none/)
    end
  end

  context 'when the aspect exists' do
    let!(:sink_methods) do
      stub_class('CoAspects::Aspects::SinkMethodsAspect') do
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

      expect(CoAspects::Aspects::SinkMethodsAspect.calls)
        .to contain_exactly(:target1, :target2)
    end

    it 'applies multiple aspects to the same method' do
      target.class_eval do
        _sink_methods; _sink_methods; def target1; end
        def non_target; end
      end

      expect(CoAspects::Aspects::SinkMethodsAspect.calls)
        .to contain_exactly(:target1, :target1)
    end

    it 'does not explode when the aspect defines new methods' do
      stub_class 'CoAspects::Aspects::OverflowAspect' do
        def self.apply(target, _)
          target.send(:define_method, :overflow) { }
        end
      end

      expect { target.class_eval { _overflow; def overflow; end } }
        .not_to raise_error
    end

    it 'does not support arguments outside a hash' do
      stub_class 'CoAspects::Aspects::OptionsAspect' do
        class << self
          attr_accessor :args
          def apply(_, options)
            @args = options[:args]
          end
        end
      end

      expect {
        target.class_eval do
          _options 'name'; def target; end
        end
      }.to raise_error(CoAspects::InvalidArgument, /name/)
    end

    it 'pass the options to the aspect' do
      stub_class 'CoAspects::Aspects::OptionsAspect' do
        class << self
          attr_accessor :options
          def apply(_, options)
            @options = options[:annotation]
          end
        end
      end

      target.class_eval do
        _options op1: 'val1', op2: 'val2'; def target; end
      end

      expect(CoAspects::Aspects::OptionsAspect.options)
        .to eq(op1: 'val1', op2: 'val2')
    end

    it 'pass the block as options to the aspect' do
      stub_class 'CoAspects::Aspects::BlockAspect' do
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

      expect(CoAspects::Aspects::BlockAspect.block).to eq('called')
    end
  end
end
