require 'newrelic_rpm'

module CoAspects
  module Aspects
    class RescueAndNotifyAspect < Aspector::Base
      around method_arg: true do |method, proxy, *args, &block|
        begin
          proxy.call(*args, &block)
        rescue => e
          NewRelic::Agent.notice_error(e, stack_trace: e.backtrace)
        end
      end
    end
  end
end
