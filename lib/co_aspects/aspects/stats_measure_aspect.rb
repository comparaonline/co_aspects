require 'statsd-instrument'

module CoAspects
  module Aspects
    # Measures a method and stores the result on StatsD.
    #
    # The key is automatically generated converting the modules, class name and
    # method name into underscores.
    #
    # The key can be overridden via the `as:` option and a dynamic part can be
    # added at the end using a block that receives the same arguments as the
    # method.
    #
    # Examples
    #
    #   module MyModule
    #     class MyClass
    #       aspects_annotations!
    #
    #       _stats_measure
    #       def task1
    #         ...
    #       end
    #
    #       _stats_measure(as: 'my_key') { |arg| arg }
    #       def task2(arg)
    #         ...
    #       end
    #     end
    #   end
    #
    #   MyClass.new.task1
    #   # => StatsD.measure('my_module.my_class.task1')
    #
    #   MyClass.new.task2('dynamic')
    #   # => StatsD.measure('my_key.dynamic')
    class StatsMeasureAspect < Aspector::Base
      around interception_arg: true, method_arg: true do |interception, method, proxy, *args, &block|
        key = interception.options[:annotation][:as] ||
          self.class.name.underscore.gsub('/', '.') + ".#{method}"
        if interception.options[:block]
          key += ".#{interception.options[:block].call(*args, &block)}"
        end
        StatsD.measure(key) do
          result = proxy.call(*args, &block)
        end
      end
    end
  end
end
