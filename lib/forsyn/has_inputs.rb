module Forsyn
  module HasInputs
    attr_reader :inputs

    def initialize
      @inputs = []
    end

    def input_from(source)
      input_from!(source)
      source.output_to!(self)
    end

    def input_from!(source)
      raise ArgumentError if source.in?(inputs)
      inputs << source
    end

    def receive(origin, data)
      raise NotImplementedError
    end

  end
end
