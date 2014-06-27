module Forsyn
  class Checker

    attr_accessor :name, :source, :responders

    def initialize(name)
      @name = name
      @responders = []
    end

    def check(sample)
      raise NotImplementedError
    end

    def output_to!(responder)
      raise ArgumentError unless responder.is_a?(Responder)
      @responders << responder
    end

  private

    def notify_responders(severity, data)
      #raise ArgumentError unless severity.in?()
      if responders.empty?
        Forsyn.logger.warn("No responders attached to Checker '#{name}'")
      end
      responders.each{ |s| s.receive(self, severity, data) }
    end

  end
end
