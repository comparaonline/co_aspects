module CoAspects
  module Aspects
    module StatsdHelper
      module_function

      def default_prefix(klass, method_name)
        klass.name.underscore.tr('/', '.') + ".#{method_name}"
      end

      def key(klass, method_name, method_args, statsd_prefix, statsd_block)
        key = statsd_prefix || default_prefix(klass, method_name)
        key += ".#{statsd_block.call(*method_args)}" if statsd_block
        key.downcase
      end
    end
  end
end
