module Forsyn
  class Responder

    attr_reader :inputs, :ouputs, :current_level

    def initialize
      @current_level = AlertState::States::NORMAL
      @inputs = []
      @outputs = []
    end

    def input_from(input)
      raise ArgumentError unless input.is_a?(Trigger)
      raise ArgumentError if input.in?(@inputs)
      input.output_to!(self)
      @inputs << input
    end

    def output_to(output)
      raise ArgumentError if output.in?(outputs)
      @outputs << output
    end

    def receive(checker, alert_state, field, data)
      raise NotImplementedError
    end

    def notify_notifiers(checker, alert_state, field, data)
      outputs.each{ |n| n.notify(self, alert_state, field, data) }
    end

  end#Responder
end
