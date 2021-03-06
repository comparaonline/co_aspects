module CoAspects
  module Aspects
    module StatsdHelper
      module_function

      def default_prefix(klass, method_name)
        klass.name.underscore.tr('/', '.') + ".#{method_name}"
      end

      def key(instance, method_name, method_args, statsd_prefix, statsd_block)
        if statsd_prefix || statsd_block
          key = statsd_prefix.to_s
          if statsd_block
            key += instance.instance_exec(*method_args, &statsd_block).to_s
          end
          key.downcase
        else
          default_prefix(instance.class, method_name)
        end
      end
    end
  end
end
