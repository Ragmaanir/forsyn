module Forsyn
  module Triggers
    class ThresholdTrigger < Trigger

      include AlertState::States
      include ThresholdBased

      attr_reader :direction

      def initialize(name, direction: :upwards, critical: , abnormal: , notable: nil)
        super(name)
        raise ArgumentError unless [:upwards, :downwards].include?(direction)
        @direction = direction
        @critical_threshold, @abnormal_threshold, @notable_threshold = critical, abnormal, notable
      end

      def check(sample, field)
        threshold, severity = exceeded_threshold_for(sample[field])

        notify_responders(severity, field, sample, threshold)
      end

    private

      def notify_responders(severity, field, sample, threshold)
        super(
          severity,
          field,
          sample: sample,
          threshold: threshold,
          message: "Value #{sample.value} exceeded threshold #{threshold} at #{sample.timestamp}"
        )
      end

    end
  end
end
