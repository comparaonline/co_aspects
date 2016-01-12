module CoAspects
  module Aspects
    class LogCallAspect < Aspector::Base
      around method_arg: true do |method, proxy, *args, &block|
        method_name = "#{self.class}.#{method}"
        args_list = args.join(',')
        result = proxy.call(*args, &block)
        Rails.logger.debug "#{method_name} called, args: (#{args_list}), result: #{result}"
        result
      end
    end
  end
end
