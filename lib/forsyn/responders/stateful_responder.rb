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
        worst_state     = AlertState.worst(relevant_states)

        if current_level != worst_state
          notify_notifiers(checker, [current_level, worst_state], data)
        end

        @current_level = worst_state
      end

    end#StatefulResponder
  end
end
