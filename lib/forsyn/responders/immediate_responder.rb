module Forsyn
  module Responders
    class ImmediateResponder < Responder

      def receive(checker, level, data)
        raise ArgumentError unless checker.in?(checkers)

        change = classify_change(current_level, level)

        if change != :no_change
          notify_notifiers(checker, change, data)
        end

        @current_level = level
      end

    end#ImmediateResponder
  end
end
