require 'newrelic_rpm'

module CoAspects
  module Aspects
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

      around method_arg: true do |method, proxy, *args, &block|
        begin
          proxy.call(*args, &block)
        rescue => e
          if RescueAndNotifyAspect.test_mode
            raise e
          else
            NewRelic::Agent.notice_error(e, stack_trace: e.backtrace)
          end
        end
      end
    end
  end
end
