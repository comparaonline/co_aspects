require 'statsd-instrument'
require_relative 'statsd_helper'

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
    # Note: The default key is used if both `as` and block are missing. If
    # either is present, the default is not used and if both are present, then
    # they are simply concatenated.
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
        key = StatsdHelper.key(self.class,
                               method,
                               args,
                               interception.options[:annotation][:as],
                               interception.options[:block])
        StatsD.measure(key) do
          proxy.call(*args, &block)
        end
      end
    end
  end
end
