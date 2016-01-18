require 'active_support/core_ext/string/inflections'

module CoAspects
  class Attacher
    def initialize
      @pending = []
    end

    def add(method_name, options, block)
      aspect_class = aspect_from_method(method_name)
      @pending << Annotation.new(aspect_class, options, block)
    end

    def attach(klass, method_name)
      blocking do
        @pending.each do |pending|
          pending.aspect.apply klass,
            method: method_name,
            annotation: pending.options,
            block: pending.block
        end
        @pending = []
      end
    end

    private

    def aspect_from_method(method_name)
      aspect_name_from_method(method_name).constantize
    rescue NameError => e
      fail AspectNotFoundError.new(e.name, method_name)
    end

    def aspect_name_from_method(annotation)
      "::CoAspects::Aspects::#{annotation[1..-1].camelize}Aspect"
    end

    def blocking
      @enabled = true unless defined?(@enabled)
      return unless @enabled
      @enabled = false
      begin
        yield
      ensure
        @enabled = true
      end
    end
  end
end
