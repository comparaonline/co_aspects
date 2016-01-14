require 'statsd-instrument'

module CoAspects
  module Aspects
    class StatsIncrementAspect < Aspector::Base
      around interception_arg: true, method_arg: true do |interception, method, proxy, *args, &block|
        proxy.call(*args, &block)
        if interception.options[:args][0]
          key = interception.options[:args][0][:as]
        else
          key = self.class.name.underscore.gsub('/', '.') + ".#{method}"
        end
        if interception.options[:block]
          key = "#{key}.#{interception.options[:block].call(*args, &block)}"
        end
        StatsD.increment(key)
      end
    end
  end
end
