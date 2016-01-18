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
      before interception_arg: true, method_arg: true do |interception, method|
        old_method_name = "#{self.class}.#{method}"
        new_method_name = interception.options[:annotation][:use]

        message = "DEPRECATION WARNING: #{old_method_name} deprecated"
        message += ", use #{new_method_name} instead" if new_method_name
        message += '.'

        Kernel.warn(message)
      end
    end
  end
end
