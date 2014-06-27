module Forsyn
  module Checkers
    class ThresholdChecker < Checker

      attr_accessor :alert_threshold, :warn_threshold

      def initialize(name, options)
        super(name)
        @alert_threshold, @warn_threshold = options.values_at(:alert, :warn)
        raise ArgumentError unless alert_threshold.is_a?(Fixnum)
      end

      def check(sample)
        if sample.value > alert_threshold
          notify_responders(:alert, sample, alert_threshold)
        elsif warn_threshold && sample.value > warn_threshold
          notify_responders(:warn, sample, warn_threshold)
        else
          notify_responders(:normal, sample, nil)
        end
      end

    private

      def notify_responders(severity, sample, threshold)
        super(
          severity,
          sample: sample,
          threshold: threshold,
          message: "Value #{sample.value} exceeded threshold #{threshold} at #{sample.timestamp}"
        )
      end

    end
  end
end
