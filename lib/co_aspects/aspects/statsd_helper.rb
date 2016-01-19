module CoAspects
  module Aspects
    module StatsdHelper
      module_function

      def default_prefix(klass, method_name)
        klass.name.underscore.tr('/', '.') + ".#{method_name}"
      end

      def key(klass, method_name, method_args, statsd_prefix, statsd_block)
        if statsd_prefix || statsd_block
          key = statsd_prefix.to_s
          key += statsd_block.call(*method_args) if statsd_block
          key.downcase
        else
          default_prefix(klass, method_name)
        end
      end
    end
  end
end
