module CoAspects
  module Aspects
    # Generates a log in the Rails logger with the method call, arguments and
    # result.
    #
    # Examples
    #
    #   class MyClass
    #     aspects_annotations!
    #
    #     _log_call
    #     def method(arg1, arg2)
    #       :success
    #     end
    #   end
    #
    #   MyClass.new.method(:first, :second)
    #   # => [DEBUG] MyClass.method called, args(:first,:second), result: :success
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
