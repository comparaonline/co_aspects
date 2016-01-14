module CoAspects
  module Aspects
    # Generates a warning message saying that the method is deprecated and
    # mentioning the new one.
    #
    # Examples
    #
    #   class MyClass
    #     aspects_annotations!
    #
    #     _deprecate use: :new_method
    #     def old_method
    #     end
    #
    #     def new_method
    #     end
    #
    #     _deprecate
    #     def deprecated_method
    #     end
    #   end
    #
    #   MyClass.new.old_method
    #   # => DEPRECATION WARNING: Target.old_method deprecated, use new_method instead.
    #
    #   MyClass.new.deprecated_method
    #   # => DEPRECATION WARNING: Target.deprecated_method deprecated.
    class DeprecateAspect < Aspector::Base
      around interception_arg: true, method_arg: true do |interception, method, proxy, *args, &block|
        old_method_name = "#{self.class}.#{method}"
        if interception.options[:args][0]
          new_method_name = interception.options[:args][0][:use]
          new_method_suggestion = ", use #{new_method_name} instead"
        end
        Kernel.warn("DEPRECATION WARNING: #{old_method_name} deprecated#{new_method_suggestion}.")
        proxy.call(*args, &block)
      end
    end
  end
end
