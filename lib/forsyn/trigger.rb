module Forsyn
  class Trigger

    attr_accessor :name, :source, :responders

    def initialize(name)
      @name = name
      @responders = []
    end

    def check(*)
      raise NotImplementedError
    end

    def output_to!(responder)
      raise ArgumentError unless responder.is_a?(Responder)
      @responders << responder
    end

  private

    def notify_responders(severity, field, data)
      #raise ArgumentError unless severity.in?()
      if responders.empty?
        Forsyn.logger.warn("No responders attached to Trigger '#{name}'")
      end
      responders.each{ |s| s.receive(self, severity, field, data) }
    end

  end
end
