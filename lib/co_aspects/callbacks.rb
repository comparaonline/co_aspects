module CoAspects
  module Callbacks
    def method_added(method_name)
      super
      (@__aspects_attacher__ ||= Attacher.new).attach(self, method_name)
    end

    def method_missing(method_name, *args, &block)
      return super unless /\A_/ =~ method_name
      args.each { |arg| fail InvalidArgument.new(arg) unless arg.kind_of?(Hash) }
      options = Hash[*args.map(&:to_a).flatten]
      (@__aspects_attacher__ ||= Attacher.new).add(method_name, options, block)
    end
  end
end
