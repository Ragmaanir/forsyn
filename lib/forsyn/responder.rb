module Forsyn
  class Responder

    attr_reader :checkers, :notifiers, :current_level

    def initialize
      @current_level = nil
      @checkers = []
      @notifiers = []
    end

    def input_from(checker)
      raise ArgumentError unless checker.is_a?(Checker)
      raise ArgumentError if checker.in?(@checkers)
      checker.output_to!(self)
      @checkers << checker
    end

    def output_to(notifier)
      raise ArgumentError if notifier.in?(notifiers)
      @notifiers << notifier
    end

    def receive(checker, alert_state, data)
      raise NotImplementedError
    end

    def notify_notifiers(checker, alert_state, data)
      notifiers.each{ |n| n.notify(self, alert_state, data) }
    end

  end#Responder
end
