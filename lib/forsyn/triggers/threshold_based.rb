module Forsyn
  module Triggers
    module ThresholdBased
      include AlertState::States

      attr_accessor :critical_threshold, :abnormal_threshold, :notable_threshold

      def thresholds
        {
          critical_threshold => CRITICAL,
          abnormal_threshold => ABNORMAL,
          notable_threshold => NOTABLE
        }
      end

      def exceeded_threshold_for(value)
        threshold, severity = thresholds.find{ |threshold,severity|
          #value > threshold if threshold
          exceeds_threshold?(value, threshold) if threshold
        }

        severity ||= NORMAL

        [threshold, severity]
      end

      def exceeds_threshold?(value, threshold)
        case direction
          when :downwards then value < threshold
          when :upwards then value > threshold
          else raise
        end
      end
    end
  end
end
