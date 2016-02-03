module CoAspects
  module Aspects
    class RescueAndNotifyError < RuntimeError
      attr_reader :newrelic_opts

      def initialize(message, newrelic_opts)
        super(message)
        @newrelic_opts = newrelic_opts
      end
    end
  end
end
