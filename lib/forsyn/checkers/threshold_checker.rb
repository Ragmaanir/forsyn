module Forsyn
  module Checkers
    class ThresholdChecker < Checker

      include AlertState::States

      attr_accessor :critical_threshold, :abnormal_threshold, :notable_threshold

      def initialize(name, critical: , abnormal: , notable: nil)
        super(name)
        @critical_threshold, @abnormal_threshold, @notable_threshold = critical, abnormal, notable
        #raise ArgumentError unless critical_threshold.is_a?(Fixnum)
      end

      def check(sample)
        if sample.value > critical_threshold
          notify_responders(CRITICAL, sample, critical_threshold)
        elsif abnormal_threshold && sample.value > abnormal_threshold
          notify_responders(ABNORMAL, sample, abnormal_threshold)
        elsif notable_threshold && sample.value > notable_threshold
          notify_responders(NOTABLE, sample, notable_threshold)
        else
          notify_responders(NORMAL, sample, nil)
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
