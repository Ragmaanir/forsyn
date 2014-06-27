module Forsyn
  module Checkers
    class DeviationChecker < Checker

      attr_accessor :average, :warn_deviation, :alert_deviation

      def check(sample)
        deviation = (sample.value - average).abs

        severity =
          if deviation > alert_deviation
            :alert
          elsif deviation > warn_deviation
            :warn
          end

        notify(severity, sample, deviation)
      end

    private

      def notify(severity, sample, deviation)
        super(
          severity,
          sample: sample,
          deviation: deviation,
          average: average,
          message: "Value #{sample.value} deviated by #{deviation} from average #{average} at #{sample.time}"
        )
      end

    end
  end
end
