require 'spec_helper'

class CoAspects::ExistingAspect; end

describe CoAspects::Annotations do
  before { class Dummy; extend CoAspects::Annotations; end }

  describe 'annotations' do
    it 'should not raise an error when the aspect exists' do
      expect { class Dummy; _existing; end }.not_to raise_error
    end

    it 'should raise an error when the aspect does not exist' do
      expect { class Dummy; _inexisting; end }.to raise_error(
        CoAspects::AspectNotFoundError, /InexistingAspect.*_inexisting/)
    end
  end
end
