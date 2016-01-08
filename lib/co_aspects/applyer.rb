module CoAspects
  class Applyer
    def initialize
      @pending = []
    end

    def add(method_name, args, block)
      aspect_class = aspect_from_method(method_name)
      @pending << AspectCall.new(aspect_class, args, block)
    end

    def apply(method_name)
      @pending.each do |pending|
        pending.aspect.apply self, method: method_name
      end
      @pending = []
    end

    private

    def aspect_from_method(method_name)
      aspect_name_from_method(method_name).constantize
    rescue NameError => e
      fail AspectNotFoundError,
        "Aspect `#{e.name}` for annotation `#{method_name}` does not exist."
    end

    def aspect_name_from_method(annotation)
      "::CoAspects::#{annotation[1..-1].camelize}Aspect"
    end
  end
end
