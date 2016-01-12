module CoAspects
  class Applyer
    def initialize
      @enabled = true
      @pending = []
    end

    def add(method_name, args, block)
      aspect_class = aspect_from_method(method_name)
      @pending << AspectCall.new(aspect_class, args, block)
    end

    def apply(klass, method_name)
      if @enabled
        @enabled = false
        @pending.each do |pending|
          pending.aspect.apply klass,
            method: method_name,
            args: pending.args,
            block: pending.block
        end
        @enabled = true
        @pending = []
      end
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
