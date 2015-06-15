module Forsyn
  module Notifiers
    class TerminalNotifier < Forsyn::Notifier
      def notify(responder, state_change, field, data)
        puts "STATE CHANGED: (#{data[:sample][:type]}:#{field}) #{state_change[0]} => #{state_change[1]}"
      end
    end
  end
end
