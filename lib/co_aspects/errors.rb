module CoAspects
  class AspectNotFoundError < StandardError
    def initialize(aspect, method)
      super("Aspect `#{aspect}` for annotation `#{method}` does not exist.")
    end
  end

  class InvalidArgument < ArgumentError
    def initialize(argument)
      super("Invalid annotation argument `#{argument}`, only hashes valid.")
    end
  end
end
