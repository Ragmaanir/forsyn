module Forsyn
  module Responders
    class ImmediateResponder < Responder

      def receive(checker, level, field, data)
        raise ArgumentError unless checker.in?(checkers)

        change = classify_change(current_level, level)

        if current_level != level
          notify_notifiers(checker, [current_level, level], field, data)
        end

        @current_level = level
      end

    end#ImmediateResponder
  end
end
