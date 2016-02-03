require 'newrelic_rpm'

module CoAspects
  module Aspects
    # Rescues any error and notifies NewRelic about it, without raising it
    # again.
    #
    # Important: If CoAspects::Aspects::RescueAndNotifyAspect.enable_test_mode!
    # is executed, then instead of calling NewRelic, it will raise the exception
    # as if this aspect didn't exist. It's to be used by tests, to see
    # exceptions being raised inside `_rescue_and_notify` annotated methods.
    #
    # Enabling test mode is not thread safe!
    #
    # Examples
    #
    #   class MyClass
    #     aspects_annotations!
    #
    #     _rescue_and_notify
    #     def perform_with_error
    #       fail 'Error'
    #     end
    #
    #     _rescue_and_notify
    #     def perform_without_error
    #       :success
    #     end
    #   end
    #
    #   MyClass.new.perform_with_error
    #   # NewRelic::Agent.notify_error(...)
    #   # => nil
    #
    #   MyClass.new.perform_without_error
    #   # => :success
    class RescueAndNotifyAspect < Aspector::Base
      class << self
        def test_mode
          !!@test_mode
        end

        def enable_test_mode!
          @test_mode = true
        end

        def disable_test_mode!
          @test_mode = false
        end
      end

      around method_arg: true do |_, proxy, *args, &block|
        begin
          proxy.call(*args, &block)
        rescue => e
          if RescueAndNotifyAspect.test_mode
            raise e
          else
            opts = {}
            if e.respond_to?(:newrelic_opts)
              opts.merge!(e.newrelic_opts)
            end
            NewRelic::Agent.notice_error(e, opts)
          end
        end
      end
    end
  end
end
