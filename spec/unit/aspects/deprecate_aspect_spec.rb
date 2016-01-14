require 'spec_helper'

describe CoAspects::Aspects::DeprecateAspect do
  before do
    stub_class('Target') do
      aspects_annotations!
      _deprecate use: :new_method
      def old_method
      end
      def new_method
      end
      _deprecate
      def deprecated_method
      end
    end
  end

  it 'warns about the deprecated method with suggestion' do
    expect(Kernel).to receive(:warn)
      .with(/old_method.*new_method/i)
    Target.new.old_method
  end

  it 'warns about the deprecated method without suggestion' do
    expect(Kernel).to receive(:warn)
      .with(/deprecated_method/i)
    Target.new.deprecated_method
  end

  it 'does not warn about non deprecated methods' do
    expect(Kernel).not_to receive(:warn)
    Target.new.new_method
  end
end
