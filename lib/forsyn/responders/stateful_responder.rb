require 'forsyn/responders/state_history'

module Forsyn
  module Responders
    class StatefulResponder < Responder

      attr_reader :cooldown

      def initialize(max_age: 30.seconds, cooldown: 10.seconds)
        super()
        @history = StateHistory.new(max_age: max_age)
        @cooldown = cooldown
      end

      def receive(checker, level, data)
        raise ArgumentError unless checker.in?(checkers)

        @history.add_state(data[:sample].timestamp, level)

        relevant_states = @history.states_since(cooldown.ago)

        worst_state = relevant_states.inject(level){ |prev, cur| worst_state(prev, cur) }

        change = classify_change(current_level, worst_state)

        if change != :no_change
          notify_notifiers(checker, change, data)
        end

        @current_level = worst_state
      end

      def worst_state(a, b)
        states = [nil, :normal, :warn, :alert]
        a_idx = states.index(a)
        b_idx = states.index(b)

        worst_idx = [a_idx, b_idx].max

        states[worst_idx]
      end

    end#StatefulResponder
  end
end
