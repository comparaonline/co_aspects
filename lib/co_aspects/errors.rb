module CoAspects
  class AspectNotFoundError < StandardError
    def initialize(aspect, method)
      super("Aspect `#{aspect}` for annotation `#{method}` does not exist.")
    end
  end
end
