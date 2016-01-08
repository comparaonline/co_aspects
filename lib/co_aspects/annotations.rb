require 'active_support/core_ext/string/inflections'

module CoAspects
  module Annotations
    def method_missing(method_name, *args, &block)
      return super unless /\A_/ =~ method_name
      aspect_name = __aspect_name_from_method(method_name)
      __store_pending_aspect(aspect_name, method_name)
    end

    private

    def __aspect_name_from_method(annotation)
      "::CoAspects::#{annotation[1..-1].camelize}Aspect"
    end

    def __store_pending_aspect(aspect_name, annotation)
      aspect = aspect_name.constantize
      __pending_aspects << AspectCall.new(aspect, args, block)
    rescue NameError => e
      fail AspectNotFoundError,
        "Aspect #{aspect_name} for annotation #{annotation} does not exist."
    end

    def __pending_aspects
      @__pending_aspects__ ||= []
    end
  end
end
