module Forsyn
  module Responders
    class StateHistory
      class State

        attr_reader :timestamp, :level

        def initialize(timestamp, level)
          raise ArgumentError unless timestamp.is_a?(Time)
          raise ArgumentError unless level# FIXME
          @timestamp = timestamp
          @level = level
        end

        def age
          Time.now - timestamp
        end
      end

      def initialize(max_age:)
        @max_age = max_age
        @states = []
      end

      def add_state(time, level)
        @states << State.new(time, level)

        forget_states
      end

      def forget_states
        @states = @states.drop_while{ |state| state.age > @max_age }
      end

      def states_since(timestamp)
        states_in_period(timestamp..Time.now)
      end

      def states_in_period(period)
        @states.map do |state|
          state.level if period.cover?(state.timestamp)
        end.compact.uniq
      end
    end#StateHistory
  end
end
