module Forsyn
  module HasOutputs
    attr_reader :outputs

    def output_to(target)
      output_to!(target)
      target.input_from!(self)
    end

    def output_to!(target)
      raise ArgumentError if target.in?(outputs)
      outputs << target
    end

    def send(data)
      outputs.each { |o| o.receive(self, data) }
    end

    # def output=(output)
    #   output.input = self
    #   @output = output
    # end

    # def output
    #   me = self
    #   Object.new do
    #     def output=(*)
    #       me.set_output(output)
    #     end
    #   end
    # end
  end
end
