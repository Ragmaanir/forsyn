module Forsyn
  module Streams
    class RateLimiter < Stream

      def initialize(max_event_count, interval, **args)
        @max_event_count = max_event_count
        @interval = interval
        @count = 0
        @interval_start = Time.now
        super(**args)
      end

      def process(event)
        if interval_passed?
          @interval_start = Time.now
          @count = 0
        end

        @count += 1

        if @count <= @max_event_count
          dispatch(event)
        end
      end

    private

      def interval_passed?
        (Time.now - @interval_start) > @interval
      end

    end
  end
end
