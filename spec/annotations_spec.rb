require 'spec_helper'

class CoAspects::DummyAspect
  def self.apply(*args); end
end

class CoAspects::MockedAspect
  class << self
    attr_accessor :methods

    def apply(_, options)
      (@methods ||= []) << options[:method]
    end
  end
end

class CoAspects::OverflowAspect
  def self.apply(klass, _)
    klass.send(:define_method, :overflow) { }
  end
end

class Dummy
  extend CoAspects::Annotations
end

describe CoAspects::Annotations do
  describe 'annotations' do
    it 'should not raise an error when the aspect exists' do
      expect { class Dummy; _dummy; end }.not_to raise_error
    end

    it 'should raise an error when the aspect does not exist' do
      expect { class Dummy; _inexisting; end }.to raise_error(
        CoAspects::AspectNotFoundError, /InexistingAspect.*_inexisting/)
    end
  end

  describe 'apply' do
    before do
      class Dummy
        _mocked; def target; end
        def non_target; end
      end
    end

    it 'should apply an aspect to the target method' do
      expect(CoAspects::MockedAspect.methods).to include(:target)
    end

    it 'should not apply an aspect to consecutive methods' do
      expect(CoAspects::MockedAspect.methods).not_to include(:non_target)
    end

    it 'should not fail if apply creates more methods' do
      expect { class Dummy; _overflow; def target; end end }.not_to raise_error
    end
  end
end
