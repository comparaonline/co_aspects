require 'active_support/core_ext/string/inflections'

module CoAspects
  module Annotations
    def method_added(method_name)
      super
      (@__aspects_attacher__ ||= Attacher.new).attach(self, method_name)
    end

    def method_missing(method_name, *args, &block)
      return super unless /\A_/ =~ method_name
      (@__aspects_attacher__ ||= Attacher.new).add(method_name, args, block)
    end
  end
end
