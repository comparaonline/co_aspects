require 'active_support/core_ext/string/inflections'

module CoAspects
  module Annotations
    def method_missing(method_name, *args, &block)
      return super unless /\A_/ =~ method_name
      aspect_class = __aspect_from_method(method_name)
      __pending_aspects << AspectCall.new(aspect_class, args, block)
    end

    private

    def __aspect_from_method(method_name)
      __aspect_name_from_method(method_name).constantize
    rescue NameError => e
      fail AspectNotFoundError,
        "Aspect `#{e.name}` for annotation `#{method_name}` does not exist."
    end

    def __aspect_name_from_method(annotation)
      "::CoAspects::#{annotation[1..-1].camelize}Aspect"
    end

    def __pending_aspects
      @__pending_aspects__ ||= []
    end
  end
end
