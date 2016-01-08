require 'spec_helper'

describe CoAspects::Annotations do
  it 'should raise an error when the annotation aspect does not exist' do
    expect {
      class Dummy
        extend CoAspects::Annotations
        _inexisting
        def doit
        end
      end
    }.to raise_error(
      CoAspects::AspectNotFoundError, /InexistingAspect.*_inexisting/)
  end
end
