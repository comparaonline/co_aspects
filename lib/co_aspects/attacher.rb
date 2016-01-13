require 'active_support/core_ext/string/inflections'

module CoAspects
  class Attacher
    def initialize
      @pending = []
    end

    def add(method_name, args, block)
      aspect_class = aspect_from_method(method_name)
      @pending << Annotation.new(aspect_class, args, block)
    end

    def attach(klass, method_name)
      blocking do
        @pending.each do |pending|
          pending.aspect.apply klass,
            method: method_name,
            args: pending.args,
            block: pending.block
        end
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

    def blocking
      @enabled = true unless defined?(@enabled)
      if @enabled
        @enabled = false
        yield
        @enabled = true
      end
    end
  end
end
