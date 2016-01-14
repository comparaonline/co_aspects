require 'statsd-instrument'

module CoAspects
  module Aspects
    # Increments a StatsD key after the method is executed.
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
    #       _stats_increment
    #       def task1
    #         ...
    #       end
    #
    #       _stats_increment(as: 'my_key') { |arg| arg }
    #       def task2(arg)
    #         ...
    #       end
    #     end
    #   end
    #
    #   MyClass.new.task1
    #   # => StatsD.increment('my_module.my_class.task1')
    #
    #   MyClass.new.task2('dynamic')
    #   # => StatsD.increment('my_key.dynamic')
    class StatsIncrementAspect < Aspector::Base
      around interception_arg: true, method_arg: true do |interception, method, proxy, *args, &block|
        result = proxy.call(*args, &block)

        key = StatsdHelper.key(self.class,
                               method,
                               args,
                               interception.options[:annotation][:as],
                               interception.options[:block])
        StatsD.increment(key)

        result
      end
    end
  end
end
