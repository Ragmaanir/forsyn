module Forsyn
  module Triggers
    class DeviationTrigger < Trigger

      include AlertState::States
      include ThresholdBased

      attr_accessor :average

      def initialize(name, average, critical: , abnormal: , notable: nil)
        super(name)
        @average = average
        @critical_threshold, @abnormal_threshold, @notable_threshold = critical, abnormal, notable
      end

      def check(sample)
        deviation = (sample.value - average).abs

        threshold, severity = exceeded_threshold_for(deviation)

        notify_responders(severity, sample, deviation, threshold)
      end

    private

      def notify_responders(severity, sample, deviation, threshold)
        super(
          severity,
          sample: sample,
          threshold: threshold,
          average: average,
          message: "Value #{sample.value} deviated by #{deviation} from average #{average} at #{sample.timestamp}"
        )
      end

    end
  end
end
